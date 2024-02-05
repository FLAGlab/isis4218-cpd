defmodule Math do
    defmacro say({:+, _, [lhs, rhs]}) do
        quote do
            lhs = unquote(lhs)
            rhs = unquote(rhs)
            IO.puts "#{lhs} plus #{rhs} is #{lhs + rhs}"
            lhs + rhs
        end
    end
    defmacro say({:*, _, [lhs, rhs]}) do
        quote do
            lhs = unquote(lhs)
            rhs = unquote(rhs)
            IO.puts "#{lhs} times #{rhs} is #{lhs * rhs}"
            lhs * rhs
        end
    end
end