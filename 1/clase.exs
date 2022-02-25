defmodule Clase do
    
        a = fn (0, _, _) -> :Fiz
        (0, 0, _) -> :FizBuzz
                (_, 0, _) -> :Buzz
                (_, _, z) -> z
        end.(x,y,z)
        
        b = fn (x, y, z) -> x + y + z end.(x,y,z)
end