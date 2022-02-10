defmodule Fib do
  def of(0), do: 1
  def of(1), do: 1
  #def of(n), do: Task.await(Task.async(fn -> Fib.of(n-1) + Fib.of(n-2) end))
  def of(n) do
    Fib.of(n-1) + Fib.of(n-2)
  end

  def asyncof(n) do
    f1 = Task.async(fn -> Fib.of(n-1) end)
    f2 = Task.async(fn -> Fib.of(n-2) end)
    Task.await(f1) + Task.await(f2)
  end

  def fib(n) do
    IO.puts "Previous Tasks"
    task = Task.async(fn -> asyncof(n) end)
    IO.puts "Continue with work"
    res = Task.await(task)
    IO.puts "Got the result: #{res}"
  end
end
