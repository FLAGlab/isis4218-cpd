defmodule Chatclient.Application do
  @moduledoc false
  use Application

  def start(_type, _args) do
    children = [
      {Task.Supervisor, name: Chatclient.TaskSupervisor}
    ]

    opts = [strategy: :one_for_one, name: Chatclient.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
