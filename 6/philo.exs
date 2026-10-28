defmodule Table do
  def start do
    chopsticks = for s <- 0..4, do: Chopstick.start(s)
    Philosopher.start(0, :"chopstick_4",
                          :"chopstick_0",
                          0)                    
    for i <- 1..4 do
        Philosopher.start(i, :"chopstick_#{rem(i - 1, 5)}",
                          :"chopstick_#{i}",
                          0)                    
            end
  end
end

defmodule Philosopher do
  def start(id, left, right, sticks) do
    fid = spawn(__MODULE__, :loop, [id, left, right, sticks])
    Process.register(fid, :"philo_#{id}")
    fid
  end

  def pick_up(philo), do: send philo, {:pick}

  def loop(id, left, right, sticks) do
    receive do
      {:state, name} -> IO.inspect Process.alive?(self())
      IO.inspect(Process.alive?(name))
      {:pick} -> if sticks < 2 do
                  IO.inspect self()
                  (Chopstick.available?(left) and Chopstick.pick_up(left, self())) or
                  (Chopstick.available?(right) and Chopstick.pick_up(right, self()))
                  IO.puts "Philosopher #{id} eating"
                  loop(id, left, right, sticks + 1) end
      {:release} ->
        (not Chopstick.available?(left) and Chopstick.release(left, self())) or
        (not Chopstick.available?(right) and Chopstick.release(right, self()))
        IO.puts "Philosopher #{id} thinking"
        loop(id, left, right, sticks - 1)
    end
  end
end

defmodule Chopstick do
  def start(id) do
    pid = spawn(__MODULE__, :loop, [true]) #spawn(fn -> loop(true) end)
    Process.register(pid, :"chopstick_#{id}")
    IO.puts :"chopstick_#{id}"
    pid
  end

  def available?(chopstick) do
    send chopstick, {:state, self()}
    receive do
      {:ok, state} -> state
      _ -> false
    end
  end

  def pick_up(chopstick, sender) do
    IO.inspect chopstick
    IO.inspect sender
    send chopstick, {:pick_up, sender}
  end

  def release(chopstick, sender) do
      IO.inspect chopstick
      IO.inspect sender
      send chopstick, {:put_down, sender}
  end

  def loop(state) do
    receive do
      {:state, sender} -> send sender, {:ok, state}
      {:pick_up, sender} -> loop(false)
      {:put_down, sender} -> loop(true)
    end
  end
end
