defmodule Fibonacci do
  def fib_iter(0, _, res), do: res
  def fib_iter(1, _, res), do: res
  def fib_iter(n, prev, prev_prev) do
    fib_iter(n-1, prev_prev, prev_prev + prev)
  end
  def fib(n) do
    IO.puts fib_iter(n, 1, 1)
  end

  def fib_rec(0), do: 1
  def fib_rec(1), do: 1
  def fib_rec(n) do
    fib_rec(n-1) + fib_rec(n-2)
  end
end

defmodule Fib do
  def of(0), do: 1
  def of(1), do: 1
  def of(n), do: Fib.of(n-1) + Fib.of(n-2)

  def fib(n) do
    IO.puts "Previous Tasks"
    task = Task.async(fn -> of(n) end)
    IO.puts "Continue with work"
    res = Task.await(task)
    IO.puts "Got the result: #{res}"
  end
end

defmodule Fib2 do
  def f(0), do: 1
  def f(1), do: 1
  def f(n) do
    t = Task.async(fn -> f(n-1) end)
    f(n-2) + Task.await(t)
  end
end

defmodule TaskFib do
  def fib(n) do
    IO.puts "Pre fib"
    task = Task.async(fn -> Fibonacci.fib_rec(n) end)
    IO.puts "More Work"
    res = Task.await(task)
    IO.puts "And the result is #{res}"
  end

  defp loop(0), do: IO.puts "End"
  defp loop(n) when n > 0 do
    task = Task.async(fn -> Fibonacci.fib(n) end)
    loop(n-1)
    IO.puts "the Fibonacci number of #{n} is #{Task.await(task)}"
  end

  def fibs(top) do
    loop(top)
  end
end


defmodule AgentFib do
  def start_link do
   Agent.start_link(fn -> %{0 => 1, 1 => 1} end)
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
        { cached_value, cache }
    end
  end

  def main(n) do
    {:ok, agent} = AgentFib.start_link()
    IO.puts fib(agent, n)
    agent
  end
end
