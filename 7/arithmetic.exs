defmodule Funs do
  def minm(l), do: minm(l, 536870911)
  def minm([], minimum), do: minimum
  def minm([h|t], minimum) when h < minimum, do: minm(t, h)
  def minm([_|t], minimum), do: minm(t, minimum)

  def maxi(l), do: maxi(l, -536870911)
  def maxi([], maximum), do: maximum
  def maxi([h|t], maximum) when h > maximum, do: maxi(t, h)
  def maxi([_|t], maximum), do: maxi(t, maximum)

  def avg(l), do: avg(l, 0, 0)
  def avg([], _, 0), do: 0
  def avg([], sum, count), do: sum / count
  def avg([h|t], sum, count), do: avg(t, sum + h, count + 1)
end

defmodule Arithmetic do
  def test do
    list = Enum.to_list(1..10_000_000)
    min = Funs.minm(list)
    max = Funs.maxi(list)
    avg = Funs.avg(list)
    IO.puts min
    IO.puts max
    IO.puts avg
  end
end

defmodule ParallelArithmetic do
  def test do
    list = Enum.to_list(1..10_000_000)
    min_pid = Task.async(fn -> Funs.minm(list) end)
    max_pid = Task.async(fn -> Funs.maxi(list) end)
    avg_pid = Task.async(fn -> Funs.avg(list) end)
    IO.puts Task.await(min_pid)
    IO.puts Task.await(max_pid)
    IO.puts Task.await(avg_pid)
  end










  def test2 do
    list = Enum.to_list(1..10_000_000)
    Task.async(fn -> IO.puts Funs.minm(list) end)
    Task.async(fn -> IO.puts Funs.maxi(list) end)
    Task.async(fn -> IO.puts Funs.avg(list) end)
  end
end
