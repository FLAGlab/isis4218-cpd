defmodule StopWatch do
  def idle() do
    receive do
      :start -> running(now(), 0)
      _ -> idle()
    end
  end

  def running(start, elapsed) do
    receive do
      {from, :stop} -> send from, {self(),  :timer.now_diff(now(), start)/ 1_000_000 + elapsed}
                        idle()
      :pause -> paused(:timer.now_diff(now(), start) + elapsed)
      _ -> running(start, elapsed)
    end
  end

  def paused(elapsed) do
    receive do
      :start -> running(now(), elapsed)
      _ -> paused(elapsed)
    end
  end

  def new(),  do: spawn(StopWatch, :idle, [])

  def start(watch), do:  send watch, :start

  def stop(watch) do
    send watch, {self(), :stop}
    receive do
      {_, elapsed} -> elapsed
    after :timer.seconds(2) ->
      :unresponsive
    end
  end

  def pause(watch), do: send watch, :pause

  defp now(), do: :erlang.timestamp
end
