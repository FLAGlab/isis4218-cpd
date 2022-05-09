defmodule Pingpong.Application do
  use Application

  def start(_type, _args) do
    Pingpong.Supervisor.start_link(:ok)
  end
end
