defmodule Pong do
  def loop do
    receive do
      {:ping} -> IO.puts "pong"
                  :global.whereis_name(:ping)
                    |> send({:pong})
                  loop()
    end
  end
end
