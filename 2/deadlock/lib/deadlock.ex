defmodule Deadlock do
  @mut MutexRegion


  defstruct name: "", ate: 0, thunk: 0

  def main do
    children = [
      Mutex.child_spec(@mut)
    ]
    {:ok, _pid} = Supervisor.start_link(children, strategy: :one_for_one)
    mutex1_id = {User, {:id, 1}}
    mutex2_id = {User, {:id, 2}}
    _p2 = spawn(fn ->
      start = fn f ->
        Mutex.await(@mut, mutex2_id)
        Mutex.await(@mut, mutex1_id)
        Process.sleep(1000)
        Mutex.release(@mut, mutex1_id)
        Mutex.release(@mut, mutex2_id)
        f.(f)
      end
      start.(start)
    end)
    run = fn f ->
      Mutex.await(@mut, mutex1_id)
      Mutex.await(@mut, mutex2_id)
      Process.sleep(1000)
      Mutex.release(@mut, mutex2_id)
      Mutex.release(@mut, mutex1_id)
      f.(f)
    end
    run.(run)
  end
end
