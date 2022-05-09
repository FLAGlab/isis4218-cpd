defmodule Client do
  def receive(msg), do: "received #{inspect msg}"
  def send(msg) do
    IO.puts "sending message..."
     Node.list()
       |> Enum.map(fn x -> IO.inspect "node #{inspect x}";
          :rpc.call(x, Client, :receive, ["<#{inspect Node.self()}> #{msg}"]) end)
  end
end
