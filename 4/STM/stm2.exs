defmodule STM2 do
  @on_load :main
  @write_point :wp_counter
  @mut TransactionLock

  def main do
    :ets.new(:registry, [:named_table, :set, :public])
    :ets.insert(:registry, {:current_transaction, nil})
    Agent.start_link(fn -> 0 end, name: @transaction_counter)
  end

  defp replicate(n, x), do: for _ <- 1..n, do: x

  def shared_variable(name, var) do
    l = replicate 9, nil
    Agent.start_link(fn -> [{var, 0} | l] end, name: name)
  end

  def stop(name) do
    Agent.stop(name, :normal)
  end

  def get_shared_variable(name) do
    [{:current_transaction, tran}] = :ets.lookup(:registry, :current_transaction)
    if (tran == nil), do: Agent.get(name, &List.first(&1, :value)), else:
      read_transaction(tran, name)
  end
"""
  def set_shared_variable(name, new_value) do
    [{:current_transaction, tran}] = :ets.lookup(:registry, :current_transaction)
    if (tran == nil) do
      IO.puts "ERROR: Can only write elements within a transaction"
    else
      write_transaction(tran, name, new_value)
    end
  end

  defp find_entry_before_read(name, tran_read_point) do
    Agent.get(name, &(&1))
      |> Enum.filter(fn item -> if elem(item, 1) <= tran_read_point, do: item end)
      |> List.first
  end

  defp read_transaction(transaction, name) do
    transaction_values = Map.get(transaction, :tran_values)
    case Map.get(transaction_values, name) do
      nil -> {value, name_version} = find_entry_before_read(name, Map.get(transaction, :read_point))
             unless name_version do
                retry(transaction, name)
             end
             Map.put(transaction_values, name, value)
             value
      value -> value
    end
  end

  defp write_transaction(transaction, name, new_val) do
    Map.get(transaction, :tran_values) |> Map.update(name, new_val)
    Map.get(transaction, :written_s_v) |> MapSet.put(name)
    seen? = Map.get(transaction, :last_seen_rev) |> Map.get(name)
    new_val
  end

  defp commit_transaction(transaction) do
    children = [
      Mutex.child_spec(@mut)
    ]
    {:ok, _pid} = Supervisor.start_link(children, strategy: :one_for_one)
    tran_id = {Transaction, {:id, 1}}
    written_names = Map.get(transaction, :written_s_v)
    unless MapSet.size(written_names) == 0 do
      lock = Mutex.await(@mut, tran_id)
      written_names
        |> Enum.map(fn item ->
                      if elem(Agent.get(item, &List.first(&1)), 1) > Map.get(transaction, :read_point) do
                        retry(transaction)
                      end
                    end)
      tran_vals = Map.get(transaction, :tran_vals)
      new_write_point = get_write_point()
      Agent.update(name,
                  fn list ->
                      [{Map.get(trans_vals, name), new_write_point} | List.delete(list, 10)]
                  end)
      Agent.update(@write_point, &(&1 + 1))
      Mutex.release(@mut, lock)
    end
  end

  defp validate vars do
    List.foldl(vars, true, fn var, acc ->
      (Agent.get(var, &Map.get(&1, :revision)) ==
       Map.get(transaction, :last_seen_rev) |> Map.get(var)) and acc
     end)
  end

  defp get_write_point do
    Agent.get(@write_point, &(&1))
  end

  defp make_transaction do
    %{:read_point =>  get_write_point(),
      :tran_values => %{},
      :written_s_v => MapSet.new()}
  end

  defp run_transaction(transaction, fun) do
    :ets.insert(:registry, {:current_transaction, transaction})
    res = try do
      result = fun.()
      commit_transaction(transaction)
      result
    catch
      nil -> IO.puts "Result is nil, which is wrong"
    end
    :ets.insert(:registry, {:current_transaction, nil})
    case res do
      nil -> run_transaction(make_transaction(), fun)
      _ -> res
    end
  end

  defp retry(transaction, name) do
    read_transaction(transaction, name)
  end

  defmacro atomically(fun) do
    quote do
      sync_atomic_transaction(unquote(fun))
    end
  end

  def sync_atomic_transaction(fun) do
    [{:current_transaction, pid}] = :ets.lookup(:registry, :current_transaction)
    case pid do
      nil -> run_transaction(make_transaction(), fun)
      _ -> fun.()
    end
  end

  def test do
    refs = Enum.map([1..10], &STM2.shared_variable(&1))
    for _ <- 1..0 do
      spawn(fn -> Enum.map(refs, fn var ->
          fn -> Enum.map([1..10],
                STM2.atomically(fn ->
                    for i <- 1..10000, do: STM2.set_shared_variable(var, &(&1 + 1))
                  end)
        ) end end)
    end)
  end
end
"""
end
