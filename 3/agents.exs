defmodule CounterAgent do
  def start_link(val) do
   Agent.start_link(fn -> val end)
  end

  def value(counter) do
    Agent.get(counter, fn val -> val end)
  end

  def inc(counter) do
    Agent.update(counter, &(&1+1))
  end

  def main do
    {:ok, counter} = CounterAgent.start_link(0)
    t1 = Task.async(fn ->
      Enum.each(1..10_000, fn _ -> CounterAgent.inc(counter) end)
    end)
    t2 = Task.async(fn ->
      Enum.each(1..10_000, fn _ -> CounterAgent.inc(counter) end)
    end)
    Task.await(t1)
    Task.await(t2)
    CounterAgent.value(counter)
  end
end

defmodule Fib do
  def of(0), do: 1
  def of(1), do: 1
  def of(n) do
    f1 = Fib.of(n-1)
    Process.sleep(1000)
    f1 + Fib.of(n-2)
  end

  def main do
    IO.puts "Previous Tasks"
    task = Task.asynch(fn -> Fib.of(20) end)
    IO.puts "Conitnue with work"
    res = Task.await(task)
    IO.puts "Got the result: #{res}"
  end
end


defmodule FibAgent do
  def start_link do
    Agent.start_link(fn -> %{ 0 => 0, 1 => 1 } end)
  end

  def fib(pid, n) when n >= 0 do
    Agent.get_and_update(pid, &do_fib(&1, n))
  end

  defp do_fib(cache, n) do
    case cache[n] do
      nil -> { n_1, cache } = do_fib(cache, n-1)
        result = n_1 + cache[n-2]
        { result, Map.put(cache, n, result) }
      cached_value ->
        { cached_value , cache }
    end
  end

  def main do
    {:ok, agent} = FibAgent.start_link()
    IO.puts FibAgent.fib(agent, 37)
  end
end
