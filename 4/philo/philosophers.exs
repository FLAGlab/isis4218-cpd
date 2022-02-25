defmodule Philo do
  alias :mnesia, as: Mnesia

  def think, do: :timer.sleep(:rand.uniform(1000))

  def eat, do: :timer.sleep(:rand.uniform(1000))

  def philosophize(num_philo) do
    left = rem(num_philo - 1, 5)
    right = rem(num_philo + 1, 5)
    do_loop(num_philo, left, right)
  end

  defp do_loop(philo, left, right) do
    think()
    if claim_chopsticks?(philo, left, right) do
      eat()
      release_chopsticks(philo)
    end
    display_philosophers_state()
    do_loop(philo, left, right)
  end

  defp claim_chopsticks?(philo, left, right) do
    {_, answ} = Mnesia.transaction(fn ->
      [{Philosopher, left, state_left}] = Mnesia.read({Philosopher, left})
      [{Philosopher, right, state_right}] = Mnesia.read({Philosopher, right})
      if state_left == :think and state_right == :think do
        Mnesia.write({Philosopher, philo, :eat})
      end
    end)
    if answ == :ok, do: true, else: false
  end

  defp release_chopsticks(id) do
    IO.puts "================================== Release chopsticks for #{id}"
    Mnesia.transaction(fn ->
      Mnesia.write({Philosopher, id, :think})
    end)
  end

  defp display_philosophers_state do
      Mnesia.transaction(fn ->
        for i <- 0..4 do
          [{Philosopher, i, state}] = Mnesia.read({Philosopher, i})
          IO.puts "Philosopher #{i} is #{state}"
        end
        IO.puts "-----------------------"
      end)
  end

  def main() do
    for i <- 1..5 do
      pid = spawn(fn -> philosophize(i) end)
    end
  end

  def start() do
    Mnesia.create_schema([node()])
    Mnesia.start()
    Mnesia.create_table(Philosopher, [attributes: [:id, :action]])
    Mnesia.dirty_write({Philosopher, 0, :think})
    Mnesia.dirty_write({Philosopher, 1, :think})
    Mnesia.dirty_write({Philosopher, 2, :think})
    Mnesia.dirty_write({Philosopher, 3, :think})
    Mnesia.dirty_write({Philosopher, 4, :think})
  end
end
