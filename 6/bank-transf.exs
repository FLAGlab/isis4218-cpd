defmodule BankAccount do
  def start(balance), do: spawn(__MODULE__, :account, [balance, 0])

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

  def transfer(from, to, amount) do
    ref = make_ref()
    send from, {:transfer, self(), amount, ref}
    commit1 = receive do
      {:ok, res} -> res
    end
    send to, {:transfer, self(), amount, ref}
    commit2 = receive do
      {:ok, res} -> res
    end
    if commit1 and commit2 do
      send from, {:commit_transfers, self(), ref}
      send to, {:commit_transfers, self(), ref}
    end
  end

  def account(balance, transfer \\ 0) do
    receive do
      {:withdraw, sender, amount, ref} ->
          if amount > balance do
            send sender, {:failure, ref, "Insufficient funds"}
            account(balance, transfer)
          else
            new_balance = balance - amount
            send sender, {:ok, ref, new_balance}
            account(new_balance, transfer)
          end
      {:transfer_to, sender, amount, ref} -> send sender, {:ok, true}
                account(balance, transfer + amount)
      {:transfer_from, sender, amount, ref} ->
            send self(), {:withdraw, self(), amount, ref}
            receive do
              {:ok, _} -> send sender, {:ok, true}
                          account(balance, transfer - amount)
              {_, _} -> send sender, {:error, false}
                        account(balance, transfer)
            end
      {:commit_transfers, sender, ref} -> send self(), {:deposit, sender, transfer, ref}
            account(balance, 0)
      {:deposit, sender, amount, ref} ->
        send sender, {:ok, ref, amount + balance}
        account(balance + amount, transfer)
      {:balance, sender, ref} ->
        send sender, {:ok, ref, balance}
        account(balance, transfer)
    end
  end
end
