defmodule Mult do
    def pp(l1, l2) do
        ppp(l1, l2, 0)
    end

    defp ppp([], [], res), do: res
    defp ppp([h1|t1], [h2|t2], res) do
        ppp(t1, t2, res + h1*h2)
    end

    def m(m1, x) do
        Enum.map(m1, &Task.async(fn -> pp(&1, x) end))
         |> Enum.map(fn res -> Task.await(res) end)
    end

    def test do
        m1 = [[1,2],[3,4]]
        x = [3,5]
        IO.inspect m(m1,x)
    end
end