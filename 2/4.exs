defmodule Four do

    def map do
        [10, 1, 7, 8]
         |> Enum.map(fn x -> spawn(fn -> x end) end)
    end


end