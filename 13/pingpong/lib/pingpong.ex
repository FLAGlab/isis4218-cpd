defmodule Pingpong do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def run(pid) do
    IO.puts "running the game"
    GenServer.cast(pid, {:run})
  end

  def run(node, {:ping, sender}) do
    GenServer.cast(node, {:ping, sender})
  end

  def init(:ok) do
    {:ok, nil}
  end

  def handle_cast({:run}, _state) do
    other = Node.list() |> Enum.random()
    IO.puts("Pinging #{other}.")
    GenServer.cast({__MODULE__, other}, {:pong, node()})
    #spawn_task(__MODULE__, :run, other, [{:ping, node()}])
    {:noreply, nil}
  end

  def handle_cast({:ping, sender}, _) do
    node = Node.list |> Enum.random
    IO.puts "Received PING from #{inspect sender}, send ping to #{node()}"
    GenServer.cast({__MODULE__, sender}, {:pong, node()})
    GenServer.cast({__MODULE__, node}, {:ping, node()})
    Process.sleep(1000)
    {:noreply, nil}
  end
  def handle_cast({:pong, sender}, _) do
    IO.puts "Received PONG from #{inspect sender}"
    {:noreply, nil}
  end
end
