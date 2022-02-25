defmodule BankAccount do
  @lock AccountLock
  defstruct balance: 0

  def account(balance), do: %BankAccount{balance: balance}

  def deposit(ba, val), do: update_in(ba.balance,  &(&1 + val))
  def withdraw(ba, val), do: update_in(ba.balance, &(&1 - val))
  def display(ba) do
    IO.puts "Current balance is #{ba.balance}"
    ba
  end
  def main do
    children = [
      Mutex.child_spec(@lock)
    ]
    {:ok, _pid} = Supervisor.start_link(children, strategy: :one_for_one)
    lock_id = :account_id
    deposit = fn(account, amount) ->
      lock = Mutex.await(@lock, lock_id)
      account = deposit(account, amount)
      IO.puts "Registered a deposit of #{amount}$"
      display(account)
      Mutex.release(@lock, lock)
    end
    withdraw = fn(account, amount) ->
      lock = Mutex.await(@lock, lock_id)
      account = withdraw(account, amount)
      IO.puts "Bank fee of #{amount}"
      display(account)
      Mutex.release(@lock, lock)
    end
    account = account(100)
    spawn(fn ->
      deposit.(account, 55)
      withdraw.(account, 3)
    end)
  end
end

defmodule Main do
  def main do
    #a = BankAccount.account(100)
  end
end
