defmodule Tokens do
  def token_exchange do
    receive do
      {other_pid, token} -> case token do
        "ping" -> send other_pid, {self(), "pong"}
        "pong" -> send other_pid, {self(), "ping"}
      end
      IO.puts token
      token_exchange()
    end
  end

  def main do
    ping = spawn(Tokens, :token_exchange, [])
    pong = spawn(Tokens, :token_exchange, [])
    send pong, {ping, "ping"}
  end
end
