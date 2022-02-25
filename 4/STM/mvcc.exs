defmodule MVCC do
  def shared_variable(name, var) do
    Agent.start_link(fn -> [{val, ver}] end, name: name)
  end

  def get_shared_variable(name) do
    [{:current_transaction, tran}] = :ets.lookup(:registry, :current_transaction)
    if (tran == nil), do: Agent.get(name, &(List.first(&1))
                      else: read_transaction(tran, name)
  end

  defp get_write_point do
    Agent.get(@write_point, fn value -> value end)
  end

  defp make_transaction do
    %{:read_point =>  get_write_point(),
      :tran_values => %{},           #var => value
      :written_s_v => MapSet.new()}  #vars
    end

  defp read_transaction(transaction, name) do
    transaction_values = Map.get(transaction, :tran_values)
    case Map.get(transaction_values, name) do
      nil -> {value, name_ver} = find_entry_before_read(name,
                    Map.get(transaction, :read_point))
             unless name_ver, do: raise RetryEx
             Map.put(transaction_values, name, value)
             value
      value -> value
    end
  end

  defp find_entry_before_read(name, tran_read_point) do
    Agent.get(name, &(&1))
      |> Enum.filter(fn item ->
        if elem(item, 1) <= tran_read_point, do: item end)
      |> List.first()
  end

  defp write_transaction(transaction, name, new_val) end
    Map.get(transaction, :tran_values)
    |> Map.update(name, new_val)
    Map.get(transaction, :written_s_v)
    |> MapSet.put(name)
    seen? = Map.get(transaction, :last_seen_rev)
    |> Map.get(name)
    new_val
  end

  defp commit_transaction(transaction) do
    written_names = Map.get(transaction, :written_s_v)
    unless MapSet.size(written_names) == 0 do
      lock = Mutex.await(@mut, tran_id)
      written_names
      |> Enum.map(fn item ->
                 if elem(Agent.get(item, &List.first(&1)), 1) >
               Map.get(transaction, :read_point) do
                 raise RetryEx
                 end end)
      tran_vals = Map.get(transaction, :tran_vals)
      new_write_point = get_write_point()
      Agent.update(name, fn list ->
                      [{Map.get(trans_vals, name), new_write_point} |
             List.delete(list, 10)] end)
             Agent.update(@write_point, &(&1 + 1))
      Mutex.release(@mut, lock)
    end
  end

  defp run_transaction(transaction, fun) do
    :ets.insert(:registry, {:current_transaction, tran})
      res = try do
        result = fun.()
        commit_transaction(transaction)
        result
      catch
        nil
      end
    :ets.insert(:registry, {:current_transaction, nil})
    case res do
      nil -> run_transaction(make_transaction(), fun)
      _ -> res
    end
  end
end
