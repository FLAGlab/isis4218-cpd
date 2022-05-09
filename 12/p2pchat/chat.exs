defmodule Client do
  def loop do
    receive do
      {:msg, msg} -> IO.inspect msg
                  loop()
    end
  end

  def send(msg) do
    Node.list()
      |> Enum.map(fn x -> send(x, {:msg, msg}) end)
  end
end
