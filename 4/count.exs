defmodule Counter do
  def start do
    :mnesia.create_schema([node()])
    :mnesia.start()
    :mnesia.create_table(Count, [attributes: [:id, :count]])
    :mnesia.dirty_write({Count, 1, 0})
  end

  def change_count do
    :mnesia.dirty_write({Count, 1, 1})
    :mnesia.dirty_read({Count, 1})
  end

  def update_two do
    :mnesia.transaction(fn ->
      :mnesia.write({Count, 1, 2})
      [{Count, id, val}] = :mnesia.read({Count, 1})
      IO.puts id
      IO.puts val
    end)
  end 

  def main do
    pid1 = Task.async(fn ->
      Enum.each(1..10_000, fn _ ->
        :mnesia.transaction(fn ->
          [{Count, _, val}] = :mnesia.read({Count, 1})
          :mnesia.write({Count, 1, val+1})
        end)
      end)
      :mnesia.dirty_read({Count, 1})
      [{Count, _id, val}] = :mnesia.dirty_read({Count, 1})
      val
    end)

    pid2 = Task.async(fn ->
      :mnesia.transaction(fn ->
        Enum.each(1..10_000, fn _ ->
        
          [{Count, _, val}] = :mnesia.read({Count, 1})
          :mnesia.write({Count, 1, val+1})
        end)
      end)
      [{Count, _id, val}] = :mnesia.dirty_read({Count, 1})
      val
    end)

    IO.puts(Task.await(pid2))
    IO.puts(Task.await(pid1))
  end
end