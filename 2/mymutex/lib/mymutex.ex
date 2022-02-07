defmodule MyMutex do
  @mut OrderMutex
  @count CountMutex

  def unordered do
    children = [
      Mutex.child_spec(@mut)
    ]
    {:ok, _pid} = Supervisor.start_link(children, strategy: :one_for_one)

    resource_id = {User, {:id, 1}}
    database_op = fn(record) ->
      IO.puts "Reading record #{record} from the database"
      Process.sleep(250)
      IO.puts "Manipulate record #{record}"
      Process.sleep(250)
      IO.puts "Saving record #{record} to the database"
      Process.sleep(250)
    end
    spawn(fn -> database_op.("First") end)
    spawn(fn -> database_op.("Second") end)
    spawn(fn -> database_op.("Third") end)
  end

  def order do
    children = [
      Mutex.child_spec(@mut)
    ]
    {:ok, _pid} = Supervisor.start_link(children, strategy: :one_for_one)

    resource_id = {User, {:id, 1}}
    database_op = fn(record) ->
      lock = Mutex.await(@mut, resource_id)
      IO.puts "Reading record #{record} from the database"
      Process.sleep(250)
      IO.puts "Manipulate record #{record}"
      Process.sleep(250)
      IO.puts "Saving record #{record} to the database"
      Process.sleep(250)
      Mutex.release(@mut, lock)
    end
    spawn(fn -> database_op.("First") end)
    spawn(fn -> database_op.("Second") end)
    spawn(fn -> database_op.("Third") end)
    3 + 5
    IO.puts "hola"
  end

  def count do
    children = [
      Mutex.child_spec(@count)
    ]
    {:ok, _pid} = Supervisor.start_link(children, strategy: :one_for_one)
    value = 0
    get_count = fn -> value end
    inc = fn ->
      val = get_count.()
      value = val + 1
    end
    spawn(fn -> Enum.each(1..10000, fn _ -> inc.() end) end)
    spawn(fn -> Enum.each(1..10000, fn _ -> inc.() end) end)
    get_count.()
  end
end
