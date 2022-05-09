defmodule PingPong do
  def pingpong do
    receive do
      {:ping, pid} -> 
            send Node.list |> Enum.filter(fn x -> x != pid end) |> List.first,
            {:pong, self()}
            pingpong()
    end
  end
end
