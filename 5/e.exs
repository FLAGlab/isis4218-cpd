defmodule E do
  def count(val) do
    receive do
      {:increment, _} -> send self(), {:increment, 5}
      count(val + 1)
    end
  end
end
