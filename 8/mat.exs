defmodule Mat do
    def mult(m1, m2) do
        []
    end

    def test do
        m1 = [[2, 1, 1],
            [3, 6, 9]]
        m2 = [[6, 1, 3, 4], 
            [9, 2, 8, 3],
            [6, 4, 1, 2]]
        res = [[27, 8, 15, 13], '~3B0']
        res2 = mult(m1, m2)
        case res2 do
            res -> IO.puts "ok"
            _ -> IO.puts "Error: #{res2}"
        end
    end

    def real_mult(m1, m2) do
        Enum.map m1, fn (x) -> Enum.map t(m2), fn (y) -> Enum.zip(x, y) 
         |> Enum.map(fn {x, y} -> x * y end)
         |> Enum.sum 
        end
        end
    end
 
    def t(m) do # transpose
        List.zip(m) |> Enum.map(&Tuple.to_list(&1))
    end 
end