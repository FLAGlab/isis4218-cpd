defmodule HOF do
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
