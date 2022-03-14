defmodule Fac do
  def do_fac(val, acc) do
    receive do
      n when is_integer(n) -> do_fac(val - 1, val * acc)
      {sender, 1} -> send sender, {self(), acc}
      do_fac(val, acc)
    end
  end

  def fac(n) do
    pid = spawn(Fac, :do_fac, [1, 1])
    send pid, n
    send pid, {self(), 1}
    receive do
      {_, acc} -> IO.puts "The factorial of #{n} is #{acc}"
    end
  end
end
