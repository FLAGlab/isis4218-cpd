defmodule Benchmark do
  def measure fun do
    fun
      |> :timer.tc
      |> elem(0)
      |> Kernel./(1_000_000)
  end
end
