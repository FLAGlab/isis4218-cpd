
defmodule DoNotDo do
    def table, do: :ets.new(:count_table, [:set, :public])

    def increment([], table) do
        [{:count, count}] = :ets.lookup(table, :count)
        count
    end
    def increment([_ | t], table) do
        [{:count, count}] = :ets.lookup(table, :count)
        :ets.insert(table, {:count, count + 1})
        increment(t, table)
    end

    def main do
        t = table()
        :ets.insert(t, {:count, 0})
        spawn(fn ->
            increment(Enum.to_list(1..10000), t)
        end)
        spawn(fn ->
            IO.puts "sum #{increment(Enum.to_list(1..10000), t)}"
        end)
  end
end