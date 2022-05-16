defmodule Pi do
  def do_count(0, p_in), do: p_in
  def do_count(n, p_in) when n > 0 do
    x =  :rand.uniform() * 2 - 1
    y =  :rand.uniform() * 2 - 1
    if (x * x + y * y <= 1) do
      do_count(n - 1, p_in + 1)
    else
      do_count(n - 1, p_in)
    end
  end

  #500*1000*1000
  def pi(n), do: 4 * do_count(n, 0) / n
end


defmodule SPP do
  def pi(n) do
    u = Task.async(fn -> Pi.do_count(div(n,4), 0)  end)
    d = Task.async(fn -> Pi.do_count(div(n,4), 0)  end)
    t = Task.async(fn -> Pi.do_count(div(n,4), 0)  end)
    c = Task.async(fn -> Pi.do_count(div(n,4), 0)  end)
    4 * (Task.await(u) +  Task.await(d) + Task.await(t) + Task.await(c)) /n
  end
end


defmodule MSPP do
  def pi(n) do
    u = Task.async(fn -> Pi.do_count(div(n,8), 0)  end)
    d = Task.async(fn -> Pi.do_count(div(n,8), 0)  end)
    t = Task.async(fn -> Pi.do_count(div(n,8), 0)  end)
    c = Task.async(fn -> Pi.do_count(div(n,8), 0)  end)
    u2 = Task.async(fn -> Pi.do_count(div(n,8), 0)  end)
    d2 = Task.async(fn -> Pi.do_count(div(n,8), 0)  end)
    t2 = Task.async(fn -> Pi.do_count(div(n,8), 0)  end)
    c2 = Task.async(fn -> Pi.do_count(div(n,8), 0)  end)
    4 * (Task.await(u) +  Task.await(d) + Task.await(t) + Task.await(c) + Task.await(u2) +  Task.await(d2) + Task.await(t2) + Task.await(c2)) /n
  end
end






















defmodule PPi do
  def pi(n) do
    section = div n, 4
    sum = for _ <- 1..4 do
      Task.async(fn -> Pi.do_count(section, 0) end)
    end
     |> List.foldl(0, fn t, acc -> Task.await(t) + acc end)
    4 * sum / n
  end
end
