defmodule Fibonacci do
  def fib(n) do fib(n, 1, 1) end
  def fib(0, next, _) do next end
  def fib(n, next, next_next) do
    fib(n-1, next_next, next + next_next)
  end
  
  
  def fibrec(0), do: 1
  def fibrec(1), do: 1
  def fibrec(n) do
    fibrec(n-2) + fibrec(n-1)
  end
end
