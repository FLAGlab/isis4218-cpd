defmodule Counter0 do
  def count(val) do
    receive do
      {sender, _} -> send sender, {self(), val}
                    count(val)
      n when is_integer(n) -> IO.puts("incrementeting the value")
            count(val + 1)
    end
  end

  def start(), do: spawn(Counter, :count, [0])

  def test do
    pid = start()
    send pid, 0
    send pid, 3
    send pid, {self(), 0}
    receive do
      {_, value} -> IO.puts "Count this far #{value}"
    end
    send pid, 0
    send pid, {self(), 0}
    receive do
      {_, value} -> IO.puts "Count this far #{value}"
    end
  end
end

defmodule Counter do
  def count(val) do
    receive do
      {:increment, _} -> count(val + 1)
      {sender, _} -> send sender, {self(), val}
      count(val)
    end
  end

  def start(), do: spawn(Counter, :count, [0])

  def test do
    pid = start()
    send pid, {:increment, 0}
    send pid, {:increment, 0}
    send pid, {self(), 0}
    receive do
      {_, value} -> IO.puts "Count this far #{value}"
    end
    send pid, {:increment, 0}
    send pid, {self(), 0}
    receive do
      {_, value} -> IO.puts "Count this far #{value}"
    end
  end
end

defmodule Counter2 do
  def count(val) do
    receive do
      {:increment, _} -> count(val + 1)
      {:stop, _} -> true
      {sender, _} -> send sender, {self(), val}
                    count(val)
      _ -> count(val)
    end
  end

  def start(), do: spawn(Counter, :count, [0])

  def test2 do
    pid = start()
    send pid, {:increment, 0}
    send pid, {:increment, 0}
    send pid, {self(), 0}
    receive do
      {_, value} -> IO.puts "Count this far #{value}"
    end
    send pid, {:stop, 0}
    send pid, {:increment, 0}
    send pid, {self(), 0}
    receive do
      {_, value} -> IO.puts "Count this far #{value}"
    end
  end
end

defmodule Counter3 do
  def start(), do: spawn(Counter3, :count, [0])
  def increment(counter), do: send counter, {:increment, 0}
  def stop(counter), do: send counter, {:stop, 0}
  def value(counter) do
    send counter, {self(), 0}
    receive do
      {_, val} -> val
    end
  end

  def count(val) do
    receive do
      {:increment, _} -> count(val + 1)
      {:stop, _} -> Process.exit(self(), :normal)
      {sender, _} -> send sender, {self(), val}
                    count(val)
      _ -> count(val)
    end
  end

  def test3 do
    pid = start()
    increment(pid)
    increment(pid)
    value(pid)
    increment(pid)
    value(pid)
  end
end
