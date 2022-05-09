defmodule Chatclient do

  def receive_message(sender, message) do
    IO.puts "<#{sender}>: #{message}"
  end

  def broadcast(msg) do
    Node.list()
      |> Enum.map(fn rec -> send_message(rec, msg) end)
  end

  def send_message(recipient, message) do
    spawn_task(__MODULE__, :receive_message, recipient, [node(), message])
  end

  def spawn_task(module, fun, recipient, args) do
    recipient
      |> remote_supervisor()
      |> Task.Supervisor.async(module, fun, args)
      |> Task.await()
  end

  defp remote_supervisor(recipient) do
    {Chatclient.TaskSupervisor, recipient}
  end
end
