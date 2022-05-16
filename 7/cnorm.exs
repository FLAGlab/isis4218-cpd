defmodule Norm do
  def pnorm(l, p) do
    power(l, p)
     |> sum()
     |> :math.pow(div(1, p))
  end

  def power([h|[]], p) do
    [:math.pow(h, p)]
  end
  def power([h|t], p) do
    h_id = Task.async(fn -> power(h, p) end)
    t_id = Task.async(fn -> power(t, p) end)
    [Task.await(h_id) | Task.await(t_id)]
  end

  def sum([h|[]]), do: h
  def sum(l) do
    {left, right} = Enum.split(l, 2)
    p1 = Task.async(fn -> sum(left) end)
    p2 = Task.async(fn -> sum(right) end)
    Task.await(p1) + Task.await(p2)
  end
end
