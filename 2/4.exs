defmodule Four do

    def map do
        [10, 1, 7, 8]
         |> Enum.map(fn x -> #Process.sleep(:rand.uniform(5000))
                     spawn(fn -> x end) end)
    end

    def map2(l, fun) do
        l
        |> Enum.map( &process_map(&1, fun))
    end

    defp process_map(elem, fun) do
        spawn (fn ->
            IO.puts "processing in process #{inspect(self())} with value #{fun.(elem)}"
        end)
    end
end
