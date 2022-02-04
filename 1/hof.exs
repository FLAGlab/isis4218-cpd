defmodule HOF do

  def operate(num, f) do
    fn (x) -> f.(num, x) end
  end

  def composition(num, f1, f2) do
    fn (x) -> f1.(num, x) |> f2.(x) end
  end


  def map([], fun) do [] end
  def map([h|t], fun) do
    [fun.(h) | map(t, fun)]
  end

  def filter([], pred?) do [] end
  def filter([h|t], pred?) do
    fn(true) -> [h | filter(t, pred?)]
      (false) -> filter(t, pred?)
    end.(pred?.(h))
  end

  def fold([], op, id) do id end
  def fold([h|t], op, id) do
    op.(h, fold(t, op, id))
  end 
end
