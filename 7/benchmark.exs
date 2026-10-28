defmodule Benchmark do
  def measure fun do
    IO.puts "Warm-up iterations"
    for _ <- 1..10, do:
      do_measure(fun)
    IO.puts "Time"
    time = test(10, fun, []) |> test_results(10, 0)    
    IO.puts "Avg execution time: #{time}"
  end

  

  defp test(0, _fun, acc), do: acc
  defp test(n, fun, acc) do
    test(n-1, fun, [do_measure(fun) | acc])  
  end
 
  defp test_results([], n, acc), do: acc/n
  defp test_results([h|t], n, acc), do: test_results(t, n, acc + h)

  def do_measure fun do
    fun
       |> :timer.tc
       |> elem(0)
       |> Kernel./(1_000_000)
  end

 
end
