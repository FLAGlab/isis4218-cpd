defmodule Hello do
  def main do
    val1 = fn -> false end
    val2 = fn -> false end
    spawn(fn ->
      :timer.sleep(2000) #yield
      if val1.() == true, do: :timer.sleep(2000); val2 = fn -> true end

      IO.puts(not (val1.() and val2.()))
    end)
    :timer.sleep(2000)
    if not val2.(), do: :timer.sleep(2000); val1 = fn -> true end
    IO.puts(not (val1.() and val2.()))
  end
end
