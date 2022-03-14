defmodule PingPong do
    def ping_y_pong do
        s = self()
        receive do
            {pid, :ping} -> :timer.sleep(2000) 
                    IO.puts "#{inspect(self())}- #{inspect(pid)} ping"
                    send pid, {self(), :pong}
            {pid, :pong} -> :timer.sleep(2000)
                    IO.puts "#{inspect(self())}-#{inspect(pid)} pong"
                    send pid, {self(), :ping}
        end
        ping_y_pong
    end

    def main do 
        p1 = spawn(PingPong, :ping_y_pong, [])
        p2 = spawn(PingPong, :ping_y_pong, [])
        p3 = spawn(PingPong, :ping_y_pong, [])
        send p1, {p2, :ping}
        send p3, {p2, :ping}
    end
end