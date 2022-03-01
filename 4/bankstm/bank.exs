defmodule STMBank do
  alias :mnesia, as: Mnesia

  def deposit(ba, val) do
    Mnesia.transaction(fn ->
      [{Account, id, balance}] = Mnesia.dirty_read({Account, ba})
      Mnesia.dirty_write({Account, id, balance + val})
    end)
  end

  def withdraw(ba, val) do
    Mnesia.transaction(fn ->
      [{Account, ba, balance}] = Mnesia.dirty_read({Account, ba})
      Mnesia.dirty_write({Account, ba, balance - val})
    end)
  end

  def transfer(from, to, val) do
    deposit(to, val)
    withdraw(from, val)
    display(from)
    display(to)
  end

  def display(ba) do
      [{Account, id, balance}] = Mnesia.dirty_read({Account, ba})
      IO.puts "Current balance of account #{id} is #{balance}"
  end

  def main do
    
  end

  def start() do
    Mnesia.create_schema([node()])
    Mnesia.start()
    Mnesia.create_table(Account, [attributes: [:id, :balance]])
    Mnesia.dirty_write({Account, :from, 500})
    Mnesia.dirty_write({Account, :to, 300})
  end
end
