defmodule STM do
  def start do
    :mnesia.create_schema([node()])
    :mnesia.start()
    :mnesia.create_table(Account, [attributes: [:id, :balance]])
    :mnesia.dirty_write({Account, 1, 5000})
    :mnesia.dirty_write({Account, 2, 5000})
  end

  def deposit(acc, amount) do
    :mnesia.transaction( fn ->
      [{Account, acc, balance}] = :mnesia.read({Account, acc})
      :mnesia.write({Account, acc, balance + amount})
    end)
  end

  def withdraw(acc, amount) do
    :mnesia.transaction( fn ->
      [{Account, acc, balance}] = :mnesia.read({Account, acc})
      :mnesia.write({Account, acc, balance - amount})
    end)
  end

  def transaction(from, to, amount) do
    :mnesia.transaction(fn ->
      withdraw(from, amount)
      deposit(to, amount)
      display(from)
      display(to)
     end)
  end

  def display(acc) do
    :mnesia.transaction(fn ->
      [{Account, acc, balance}] = :mnesia.read({Account, acc})
      IO.puts "The account #{acc}, has a balance of #{balance}"
    end)
  end

  def test do
    for i <- 1..10, do: spawn(fn -> STM.transaction(:rand.uniform(2), :rand.uniform(2), i * 10) end)
  end


end
