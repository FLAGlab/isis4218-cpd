defmodule Functions do
    
    @doc """
    Function definition
    """
    def bar(x, y) do
        x-y
    end

    @doc """
    Shorthand function definition
    """
    def foo(x, y), do: x+y

    @doc """
    Recursive function defining a RECURSIVE PROVESS
    """
    def fact(n) do
        if n == 0 do
            1
        else
            n * fact(n-1) 
        end
    end

    @doc """
    Recursive function defining an ITERATIVE PROCESS
    (using tail recursion or tail call optimization)
    """
    def fact(0) do
        1
    end
    def fact(n), do: do_fact(n, 1)
    defp do_fact(n, acc) do
        if n == 0 do
            acc
        else
            do_fact(n-1, acc*n)
        end
    end
end