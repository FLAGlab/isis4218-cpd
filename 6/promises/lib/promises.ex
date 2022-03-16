defmodule Promise do
  def meaning_of_life(promise) do
    Pinky.extract(promise)
  end

  def pinky_test() do
    p = Pinky.promise(fn -> 42 end)
    #{:ok, ft} = 
    IO.puts "The meaning of life is #{inspect meaning_of_life(p)}"
  end
end
