defmodule SatProp do
  def satisfy(list, fun) when length(list) < 1_000 do
    do_satisfy(list, fun)
  end
  def satisfy(list, fun) do
    {left, right} = Enum.split(list, div(length(list), 2))
    lp = Task.async(fn -> satisfy(left, fun) end)
    res_r = satisfy(right, fun)
    res_r || Task.await(lp)
  end

  defp do_satisfy([], _), do: false
  defp do_satisfy([h|t], fun) do
    if fun.(h), do: h, else: do_satisfy(t, fun)
  end

  def satisfyl(list, fun) when length(list) < 1_000 do
    do_satisfy(list, fun)
  end
  def satisfyl(list, fun) do
    {left, right} = Enum.split(list, div(length(list), 2))
    lp = Task.async(fn -> satisfy(left, fun) end)
    res_r = satisfy(right, fun)
    res_l = Task.await(lp)
    if res_l, do: res_l, else: res_r
  end

  def test do
    l = for _ <- 1..1_000_000, do: :rand.uniform(1_000_000)
    satisfy(l, fn x -> x > 15_000 end)
    satisfyl(l, fn x -> x > 15_005 end)
  end
end
