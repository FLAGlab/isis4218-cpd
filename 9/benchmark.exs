defmodule Benchmark do
  def measure fun do
    for _ <- 1..10, do:
      IO.puts "Warm-up time: #{do_measure(fun)}"
    for i <- 1..10, do:
        IO.puts "Measurement #{i}: #{do_measure(fun)}"
  end

  def do_measure fun do
    fun
       |> :timer.tc
       |> elem(0)
       |> Kernel./(1_000_000)
  end
end
