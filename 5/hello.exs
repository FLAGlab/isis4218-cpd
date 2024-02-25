defmodule Hello do
  def say_hello(msg) do
    IO.puts "Hello #{msg}"
  end

  def greet do
    receive do
      {:ok, msg} -> IO.puts msg
      {sender, msg} -> 
          IO.puts "Message!"
          size = String.length(msg)
          number = String.slice(msg, size-1..size)
            |> String.to_integer()
          if rem(number, 2) == 0 do 
            send sender, {:ok, "Hello, #{msg}"}
          else send sender, {self(), " a.#{msg}"}
          end
        greet()
    end
  end
end

defmodule HelloMessage do
  def greet do
    receive do
      {sender, msg} -> 
      send sender, {:ok, "Hello #{msg}"}
    end
  end

  def run do
    pid = spawn(HelloMessage, :greet, [])
    send pid, {self(), "World"}
    receive do 
      {:ok, msg} -> IO.puts msg 
    end
  end
end