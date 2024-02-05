defmodule Lists do

    #get the length of a list
    @spec len(list(Literals)) :: integer() 
    def len(list) do
        defp len_iter(list, longitud) do
            case list do
                [] -> longitud
                [H | T] -> len_iter(T, longitud + 1)
            end
        end
        len_iter(list, 0)
    end

    def buen_len(list), do: len_iter(list, 0)
    defp len_iter([], long), do: long
    defp len_iter([H|T], long) do
        len_iter(T, long + 1)
    end


    def concat(l1, l2) do
        concat_iter(l1, l2, [])
    end

    defp concat_iter([], l2, res) do
        concat_iter(l2, res)
    end

    defp concat_iter([H|T], l2, res) do
       concat_iter(T, l2, [H|res])
    end

    defp concat_iter([], res) do
        res |> Enum.reverse
    end

    defp concat_iter([H|T], res) do
       concat_iter(T, [H|res])
    end
    








    







end