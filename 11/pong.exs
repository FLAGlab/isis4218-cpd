defmodule Pong do
  def loop do
    receive do
      {:ping, client} -> send client, :pong
      {:pong, client} -> send client, :ping
    end
  end
end
