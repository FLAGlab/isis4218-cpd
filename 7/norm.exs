defmodule Norm do
  require Benchmark

  def norm(arr, p) do
    power(arr, p)
     |> sum()
     |> :math.pow(1 / p)
  end

  def sum(arr), do: do_sum(arr, 0)
  defp do_sum([], acc), do: acc
  defp do_sum([h|t], acc), do: do_sum(t, h + acc)

  def power(l, p), do: do_power(l, p, [])
  def do_power([], _, pows), do: Enum.reverse pows
  def do_power([h | t], p, pows) do
    do_power(t, p, [:math.pow(h, p) | pows])
  end

  def sum_power(arr) do
    power(arr, 2)
  end

  def para_norm(arr, p) do
    size = Enum.count(arr)
    elems = :erlang.ceil(size/:erlang.system_info(:logical_processors_available))
    Enum.chunk_every(arr, elems)
      |> Task.async_stream(&sum_power/1)
      |> Enum.reduce([], fn {:ok, list_val}, acc -> [list_val | acc] end)
      |> Task.async_stream(&sum/1)
      |> Enum.to_list()
      |> Enum.reduce(0, fn {:ok, val}, acc -> val + acc end)
      |> :math.pow(1 / p)    
  end

  def test(l) do
  #a = for x <- 1..1000000, into: MapSet.new(), do: :random.uniform(10000000)
  #l = MapSet.to_list(a)
    Benchmark.measure(fn -> norm(l, 2) end)
  end

  def test2(l) do
    Benchmark.measure(fn -> para_norm(l, 2) end)
  end
end




defmodule PNorm do
  def norm(arr, p) do
    {left, right} = Enum.split(arr, div(length(arr), 3))
    l_pid = Task.async(fn -> Norm.power(left, p) |> Norm.sum() end)
    r_pid = Task.async(fn -> Norm.power(right, p) |> Norm.sum() end)
    sum = Task.await(l_pid) + Task.await(r_pid)
    :math.pow(sum, 1 / p)
  end

  def test(l) do
    Benchmark.measure(fn -> norm(l, 2) end)
  end
end
