defmodule Pong do
  def loop do
    receive do
      {:ping, name, msg} -> IO.puts "ping #{msg}"
                  :global.whereis_name(name)
                    |> send({:pong, :pongnode, msg + 1})
                  loop()
    end
  end
end
