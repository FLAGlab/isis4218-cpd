defmodule SampleWorker do
  use GenServer

  #API
  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  def stop(pid) do
    GenServer.call(pid, :stop)
  end

  #Callbacks
  def handle_call(:stop, _from, state) do
    {:stop, :normal, :ok, state}
  end
end
