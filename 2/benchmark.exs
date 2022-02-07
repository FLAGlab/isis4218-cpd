defmodule Benchmark do
  @doc """
  Functions measures the execution time of a function in seconds
  The function to measure must be wrapped inside a lambda (shorthand fn -> fun end)
  """
  def measure fun do
    fun
      |> :timer.tc
      |> elem(0)
      |> Kernel./(1_000_000)
  end
end