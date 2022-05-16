defmodule Sum do
  @cores  System.schedulers_online
  @arr Enum.to_list(0..1_00_000)

  def seq_sum do
    List.foldl(@arr, 0, fn x, acc -> x + acc end)
  end

  def seq_par_sum do
    @arr
     |> Enum.map(fn elem -> Task.async(fn -> elem end) end)
     |> Enum.map(&Task.await/1)
     |> List.foldl(0, fn x, acc -> x + acc end)
  end



















  def sum do
    Enum.chunk_every(@arr, div(length(@arr), 2))
     |> Enum.map(&Task.async(fn -> List.foldl(&1, 0, fn elem, acc -> elem + acc end) end))
     |> Enum.map(&Task.await/1)
     |> List.foldl(0, fn x, acc -> x + acc end)
  end







  def naive_sum do
    Enum.chunk_every(@arr, 1_000)
     |> Enum.map(&Task.async(fn -> List.foldl(&1, 0, fn elem, acc -> elem + acc end) end))
     |> Enum.map(&Task.await/1)
     |> List.foldl(0, fn x, acc -> x + acc end)
  end














  def fork_sum do
    do_fork_sum(@arr, length(@arr))
  end
  defp do_fork_sum(list, len) when len <= 1000 do
    List.foldl(list, 0, fn x, acc -> x + acc end)
  end
  defp do_fork_sum(list, len) do
    {left, right} = Enum.split(list, div(len, 2))
    l = Task.async(fn -> do_fork_sum(left, div(len, 2)) end)
    r = Task.async(fn -> do_fork_sum(right, div(len, 2)) end)
    Task.await(l) + Task.await(r)
  end




  def super_fork_sum, do: super_fork_sum(@arr, length(@arr))
  defp super_fork_sum(list, len) when len <= 1000 do 
    List.foldl(list, 0, fn x, acc -> x + acc end)
  end
  defp super_fork_sum(l, len) do
    {left, right} = Enum.split(l, div(len, 2))
    lp = Task.async(fn -> super_fork_sum(left, div(len, 2)) end)
    rp = super_fork_sum(right, div(len, 2))
    Task.await(lp) + rp
  end

  def fork_join_sum, do: fork_join_sum2(@arr)
  defp fork_join_sum(list) when length(list) < 1_000, do:
    List.foldl(list, 0, fn x, acc -> x + acc end)
  defp fork_join_sum(l) do
    {left, right} = Enum.split(l, div(length(l), 2))
    lp = Task.async(fn -> fork_join_sum(left) end)
    rp = Task.async(fn -> fork_join_sum(right) end)
    Task.await(lp) + Task.await(rp)
  end
  defp fork_join_sum2(list) when length(list) < 1_000, do:
    List.foldl(list, 0, fn x, acc -> x + acc end)
  defp fork_join_sum2(l) do
    Enum.chunk_every(@arr, div(length(l), @cores))
     |> Enum.map(fn x -> Task.async(fn -> fork_join_sum2(x) end) end)
     |> List.foldl(0, fn x, acc -> Task.await(x) + acc end)
  end

  def test do
    IO.puts "\n Sequentially adding up elements"
    Benchmark.measure(&seq_sum/0)
    IO.puts "\n Sequential-parallelism summ elements"
    Benchmark.measure(&seq_par_sum/0)
    IO.puts "\n Parallel exhaustive cores sum elements"
    Benchmark.measure(&sum/0)
    IO.puts "\n Naive parallel sum elements"
    Benchmark.measure(&naive_sum/0)
    IO.puts "\n Fork sum elements"
    Benchmark.measure(&fork_sum/0)
    IO.puts "\n Better fork sum elements"
    Benchmark.measure(&super_fork_sum/0)
    IO.puts "\n Fork/Join sum elements"
    Benchmark.measure(&fork_join_sum/0)
  end
end
