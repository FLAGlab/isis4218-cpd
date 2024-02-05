defmodule MacroEx do
    defmacro while(expression, do: block) do
        quote do
            try do
                for _ <- Stream.cycle([:ok]) do
                    if unquote(expression) do
                        unquote(block)
                    else
                        MacroEx.break
                    end
                end
            catch
                :break -> :ok
            end
        end
    end

    def break, do: throw :break
end