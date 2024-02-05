defmodule MacroUse do
    import MacroEx

    def loop do
        while true do
            number = :rand.uniform(10)
            if number < 5  do
                MacroEx.break
            else
                IO.puts("Large number #{number}") 
            end
        end
    end
end