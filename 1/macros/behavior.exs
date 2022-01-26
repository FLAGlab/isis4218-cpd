defmodule Behavior do
  #use Agent
  defmacro proceed() do
    quote do
    end
  end

  def foo(msg) do
    proceed()
  end


end
