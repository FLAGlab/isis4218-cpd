defmodule Counting do
  def count do 0 end

  def increment([], acc) do
    acc
  end
  def increment([_ | t], acc) do
    increment(t, acc + 1)
  end

  def main do
    spawn(fn ->
        IO.puts increment(Enum.to_list(1..10000), count())
    end)
    spawn(fn ->
        IO.puts increment(Enum.to_list(1..10000), count())
    end)
  end


















  def main2 do
    spawn(fn ->
        res = increment(Enum.to_list(1..10000), count())
        spawn(fn ->
            IO.puts increment(Enum.to_list(1..10000), res)
        end)
    end)
  end
end

















defmodule AgentCounting do
  def start_link(val) do
    Agent.start_link(fn -> val end)
  end

  def value(counter) do
    Agent.get(counter, fn val -> val end)
  end

  def inc(counter) do
    Agent.update(counter, fn val -> val + 1 end)
  end

  def main do
    {:ok, counter} = AgentCounting.start_link(0)
    t1 = Task.async(fn -> Enum.each(1..10000, fn _ -> AgentCounting.inc(counter) end) end)
    t2 = Task.async(fn -> Enum.each(1..10000, fn _ -> AgentCounting.inc(counter) end) end)
    Task.await(t1)
    Task.await(t2)
    AgentCounting.value(counter)
  end

end
