defmodule Calculator do
  def add(lhs, rhs), do: IO.puts lhs + rhs
  def multiply(lhs, rhs), do: lhs * rhs
  def divide(lhs, rhs), do: lhs / rhs
  def subtract(lhs, rhs), do: lhs - rhs
end


defmodule HelloMessage do
  def greet do
    receive do
      {sender, msg} -> send sender, {:ok, "Hello, #{msg}"}
      greet
    end
  end

  def test2 do
    pid = spawn(HelloMessage, :greet2, [])
    send pid, {self(), "World"}
    receive do {:ok, message} -> IO.puts message end
    send pid, {self(), "Mundo"}
    receive do {:ok, message} -> IO.puts message end
  end

  def test do
    pid = spawn(HelloMessage, :greet, [])
    send pid, {self(), "World"}
    receive do {:ok, message} -> IO.puts message end
    send pid, {self(), "Mundo"}
    receive do
      {:ok, message} -> IO.puts message
    after 500 -> IO.puts "The greeter is away" end
  end

  def greet2 do
    receive do
      {sender, msg} -> send sender, {:ok, "Hello, #{msg}"}
      greet2
    end
  end
end
