defmodule Chat.Server do
  use GenServer
  alias Chat.Handler
  require Logger

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(port: port) do
    opts = [{:port, port}]
    {:ok, pid} = :ranch.start_listener(:chat, :ranch_tcp, opts, Handler, [])

    Logger.info(fn -> "Listening for connections on port #{port}" end)
    {:ok, pid}
  end
end
