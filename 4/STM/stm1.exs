defmodule STM1 do
  @on_load :main
  @transaction_counter :t_counter
  @mut TransactionLock

  def main do
    :ets.new(:registry, [:named_table, :set, :public])
    :ets.insert(:registry, {:current_transaction, nil})
    Agent.start_link(fn -> 0 end, name: @transaction_counter)
  end

  def shared_variable(name, var) do
    Agent.start_link(fn -> %{:value => var, :revision => 0} end, name: name)
  end

  def stop(name) do
    Agent.stop(name, :normal)
  end

  def get_shared_variable(name) do
    [{:current_transaction, tran}] = :ets.lookup(:registry, :current_transaction)
    if (tid == nil), do: Agent.get(name, &Map.get(&1, :value)), else:
      read_transaction(tran, name)
  end

  def set_shared_variable(name, new_value) do
    [{:current_transaction, tran}] = :ets.lookup(:registry, :current_transaction)
    if (tran == nil) do
      IO.puts "ERROR: Can only write elements within a transaction"
    else
      write_transaction(tran, name, new_val)
    end
  end

  defp read_transaction(transaction, name) do
    transaction_values = Map.get(transaction, :tran_values)
    res = case Map.get(transaction_values, name) do
      nil -> %{:value => val, :revision => rev} = Agent.get(name, fn map -> map end)
              Map.put(transaction_values, name, val)
              Map.get(transaction, :last_seen_rev) |> Map.update(name, rev)
              val
      value -> value
    end
    res
  end

  defp write_transaction(transaction, name, new_val) do
    Map.get(transaction, :tran_values) |> Map.update(name, new_val)
    Map.get(transaction, :written_s_v) |> MapSet.put(name)
    seen? = Map.get(transaction, :last_seen_rev) |> Map.get(name)
    unless seen?, do:
         Map.get(transaction, :last_seen_rev)
      |> Map.put(name, Agent.get(name, &Map.get(&1, :revision)))
    new_val
  end

  defp commit_transaction(transaction) do
    children = [
      Mutex.child_spec(@mut)
    ]
    {:ok, _pid} = Supervisor.start_link(children, strategy: :one_for_one)
    tran_id = {Transaction, {:id, 1}}
    lock = Mutex.await(@mut, tran_id)
    success = Map.get(transaction, :tran_values) |> Map.keys() |> validate()
    if success do
      Agent.update(name, &Map.update(&1, :value, new_value, fn _ -> new_value end))
      Agent.update(name, &Map.update(&1, :revision, fn n -> n + 1 end))
    end
    Mutex.release(@mut, lock)
    success
  end

  defp validate vars do
    List.foldl(vars, true, fn var, acc ->
      (Agent.get(var, &Map.get(&1, :revision)) ==
       Map.get(transaction, :last_seen_rev) |> Map.get(var)) and acc
     end)
  end

  defp next_transaction do
    Agent.get_and_update(@transaction_counter, &(&1 + 1))
  end

  defp make_transaction do
    %{:id =>  next_transaction(),
      :tran_values => %{},
      :written_s_v => MapSet.new(),
      :last_seen_rev => %{}}
  end

  defp run_transaction(transaction, fun) do
    :ets.insert(:registry, {:current_transaction, transaction})
    result = fun.()
    :ets.insert(:registry, {:current_transaction, nil})
    case commit_transaction(transaction) do
      true -> result
      _ -> run_transaction(make_transaction(), fun)
    end
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
    refs = Enum.map([1..10], &STM1.shared_variable(&1))
    for _ <- 1..0 do
      spawn(fn -> Enum.map(refs, fn var ->
          fn -> Enum.map([1..10],
                STM1.atomically(fn ->
                    for _ <- 1..10_000, do: STM1.set_shared_variable(var, &(&1 + 1))
                  end))
                end end)
          end)
    end
  end

end
