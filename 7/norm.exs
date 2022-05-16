defmodule Norm do
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
end

defmodule PNorm do
  def norm(arr, p) do
    {left, right} = Enum.split(arr, div(length(arr), 3))
    l_pid = Task.async(fn -> Norm.power(left, p) |> Norm.sum() end)
    r_pid = Task.async(fn -> Norm.power(right, p) |> Norm.sum() end)
    sum = Task.await(l_pid) + Task.await(r_pid)
    :math.pow(sum, 1 / p)
  end

  def test do
    Enum.to_list(1..10_000_000)
     |> norm(2)
  end
end
