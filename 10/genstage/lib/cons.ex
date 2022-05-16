defmodule Consumer do
  use GenStage

  def init(:ok) do
    {:consumer, :state}
  end

  def handle_events(events, _from, state) do
    Process.sleep(1000)
    IO.inspect(events)
    {:noreply, [], state}
  end
end
