defmodule CounterActor do
  def loop(count) do
    receive do
      {:next} -> IO.puts "counter is: #{count}"
            loop(count + 1)
    end
  end
end



defmodule CounterActorState do
  def start(count), do: spawn(__MODULE__, :loop, [count])

  def next(counter) do
    ref = make_ref()
    send counter, {:next, self(), ref}
    receive do
      {:ok, ^ref, count} -> count
    end
  end

  def loop(count) do
    receive do
      {:next, sender, ref} -> send sender, {:ok, ref, count}
            loop(count + 1)
      {:shutdown} -> exit(:normal)
    end
  end

  def kill(counter) do
    send counter, {:shutdown}
  end
end
