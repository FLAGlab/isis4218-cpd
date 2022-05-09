defmodule Pingpong.Supervisor do
  use Supervisor

  def start_link(:ok) do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      supervisor(Task.Supervisor, [[name: Pingpong.TasksSupervisor]])
    ]

    supervise(children, [strategy: :one_for_one, name: Pingpong.Supervisor])
  end
end
