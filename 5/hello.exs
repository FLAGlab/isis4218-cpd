defmodule Hello do
  def say_hello(msg) do
    IO.puts "Hello #{msg}"
  end

  def greet do
    receive do
      {:ok, msg} -> IO.puts msg
      {sender, msg} -> 
            IO.puts "Message!"
            if rem(Enum.random(1..2), 2) == 0 do 
              send sender, {:ok, "Hello, #{msg}"}
              else send sender, {self(), " a.#{msg}"}
              end
        greet
    end
  end

end
