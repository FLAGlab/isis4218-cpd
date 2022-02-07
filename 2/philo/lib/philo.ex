defmodule Philosophers do
  @philo Philosophers

  defstruct name: "", ate: 0, thunk: 0

  def main do
    children = [
      Mutex.child_spec(@philo)
    ]
    {:ok, _pid} = Supervisor.start_link(children, strategy: :one_for_one)

    chopsticks = [:cpstk1, :cpstk2, :cpstk3, :cpstk4, :cpstk5]
    rand_l = :rand.uniform(5) - 1
    chpstk_idl = {@philo, Enum.at(chopsticks, rand_l)}
    rand_r = :rand.uniform(5) - 1
    chpstk_idr = {@philo, Enum.at(chopsticks, rand_r)}
    lock_l = lock_r = false
    _eat = fn ->
      if(chpstk_idl < chpstk_idr) do
        lock_l = Mutex.await(@philo, chpstk_idl)
        lock_r = Mutex.await(@philo, chpstk_idr)
      else
        lock_l = Mutex.await(@philo, chpstk_idr)
        lock_r = Mutex.await(@philo, chpstk_idl)
      end
      IO.puts("Philosopher #{inspect self()} is eating")
      Process.sleep(1000)
      Mutex.release(@philo, lock_l)
      Mutex.release(@philo, lock_r)
    end
    p1 = spawn(fn -> main() end) #philo1
    IO.puts "Philosopher #{inspect p1}"
    p2 = spawn(fn -> main() end) #philo2
    IO.puts "Philosopher #{inspect p2}"
    p3 = spawn(fn -> main() end) #philo3
    IO.puts "Philosopher #{inspect p3}"
    p4 = spawn(fn -> main() end) #philo4
    IO.puts "Philosopher #{inspect p4}"
    p5 = spawn(fn -> main() end) #philo5
    IO.puts "Philosopher #{inspect p5}"
  end
end
