defmodule Test do


def main do
    list = 1..100
    p1 = spawn(fn -> Enum.filter(list, fn x -> rem(x, 2) == 0 end)
                        |> List.foldl(0, &(&1 + &2)) 
                        |> IO.puts() end)
    p2 = spawn(fn -> Enum.filter(list, fn x -> rem(x, 2) == 1 end)
                        |> List.foldl(0, &(&1 + &2)) 
                        |> IO.puts() end)

end

end