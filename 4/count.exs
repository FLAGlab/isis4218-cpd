

:mnesia.create_schema([node()])
:mnesia.start()
:mnesia.create_table(Count, [attributes: [:id, :count]])
:mnesia.dirty_write({Count, 1, 0})

:mnesia.dirty_write({Count, 1, 1})
:mnesia.dirty_read({Count, 1})

:mnesia.transaction(fn ->
  :mnesia.write({Count, 1, 2})
  [{Count, id, val}] = :mneasia.read({Count, 1})
  IO.puts id
  IO.puts val
end)

pid1 = Task.async(fn ->
  Enum.each(1..1_0000, fn _ ->
    :mnesia.transaction(fn ->
      [{Count, _, val}] = :mneasia.read({Count, 1})
      :mnesia.write({Count, 1, val+1})
    end)
  end)
end)

pid2 = Task.async(fn ->
  Enum.each(1..1_0000, fn _ ->
    :mnesia.transaction(fn ->
      [{Count, _, val}] = :mneasia.read({Count, 1})
      :mnesia.write({Count, 1, val+1})
    end)
  end)
end)

IO.puts Task.await(pid2)
IO.puts Task.await(pid1)
