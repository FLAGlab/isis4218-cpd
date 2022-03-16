defmodule BankAccount do
  def start(balance), do: spawn(__MODULE__, :account, [balance])

  def withdraw(account, amount) do
    ref = make_ref()
    send account, {:withdraw, self(), amount, ref}
    receive do
      {:ok, ^ref, new_bal} -> IO.puts "your new balance is #{new_bal}"
      {:failure, ^ref, msg} -> IO.puts msg
      _ -> IO.puts "unknown error"
    end
  end

  def deposit(account, amount) do
    ref = make_ref()
    send account, {:deposit, self(), amount, ref}
    receive do
      {:ok, ^ref, new_bal} -> IO.puts "your new balance is #{new_bal}"
      _ -> IO.puts "Something bad happened"
    end
  end

  def balance(account) do
    ref = make_ref()
    send account, {:balance, self(), ref}
    receive do
      {:ok, ^ref, bal} -> IO.puts "Your balance is #{bal}"
    end
  end

  def account(balance) do
    receive do
      {:withdraw, sender, amount, ref} ->
          if amount > balance do
            send sender, {:failure, ref, "Insufficient funds"}
            account(balance)
          else
            new_balance = balance - amount
            send sender, {:ok, ref, new_balance}
            account(new_balance)
          end
      {:deposit, sender, amount, ref} ->
        send sender, {:ok, ref, amount + balance}
        account(balance + amount)
      {:balance, sender, ref} ->
        send sender, {:ok, ref, balance}
        account(balance)
    end
  end
end
