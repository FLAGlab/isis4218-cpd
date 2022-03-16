defmodule Table do
  def start do
  chopsticks = for s <- 0..4, do: Chopstick.start(s)
  for i <- 0..4 do
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
  end

  def pick_up(philo), do: send philo, {:pick}

  def loop(id, left, right, sticks) do
    receive do
      {:pick} -> if sticks < 2 do
                  (Chopstick.available?(left) and Chopstick.pick_up(left, self())) or
                  (Chopstick.available?(right) and Chopsick.pick_up(right, self()))
                  IO.puts "Philosopher #{id} eating"
                  loop(id, left, right, sticks + 1) end
      {:release} ->
        (Chopstick.available?(left) and Chopstick.release(left, self())) or
        (Chopstick.available?(right) and Chopsick.release(right, self()))
        IO.puts "Philosopher #{id} thinking"
        loop(id, left, right, sticks - 1)
    end
  end
end

defmodule Chopstick do
  def start(id) do
    pid = spawn(__MODULE__, :loop, [true])
    Process.register(pid, :"chopstick_#{id}")
  end

  def available?(chopstick) do
    send chopstick, {:state, self()}
    receive do
      {:ok, state} -> state
      _ -> false
    end
  end

  def pick_up(chopstick, sender) do
    send chopstick, {:pick_up, sender}
  end

  def release(chopstick, sender) do
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
