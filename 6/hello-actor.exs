defmodule HelloActor do
  def loop() do
    receive do
      {:hello, msg} -> IO.puts "Hello #{msg}"
      {:hola, msg} -> IO.puts "Hola, #{msg}!"
      {:shutdown} -> exit(:normal)
      _ -> IO.puts "Sorry I don't seem to understand that"
    end
    loop()
  end









  def loop2 do
    receive do
      {:hello, msg} -> :timer.sleep(5000);  IO.puts "Hello #{msg}"
      _ -> IO.puts "Sorry I don't seem to understand that"
    end
    loop2()
  end
end





defmodule Drown do
  def main() do
    actor  = spawn(&HelloActor.loop/0)
    for i <- 1..1_000_000, do: send actor, {:hello, "message #{i}"}
  end

  def main2() do
    actor  = spawn(&HelloActor.loop2/0)
    for i <- 1..1_000_000_000_000, do: send actor, {:hello, "message #{i}"}
  end
end
