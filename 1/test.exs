defmodule Test do

    def hello_world(s) do
        fn(s2) -> s <> s2 end
    end

    def for(start, condition, increment, operation) do
        for_iter(start, condition, increment, operation, 0)
    end
    defp for_iter(start, condition, increment, operation, res) do 
        if condition.(start) do
            for_iter(increment.(start), condition, increment, operation, operation.(start,res))
        else 
            res
        end
    end

end
