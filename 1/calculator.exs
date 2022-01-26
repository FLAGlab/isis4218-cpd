defmodule Calculator do
  def calculate(f) do
    &(f.(&1, &2))
  end
end
