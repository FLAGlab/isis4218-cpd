defmodule B do
  def main do
  x = 5
  IO.puts "operation before with value #{x}"
  spawn(fn ->
    #:timer.sleep(5000)
    x = x + 3
    IO.puts x
  end)
  x = x + 5
  IO.puts " other operation #{x}"
  end

  def odds_even(l) do
    pid_even = spawn(fn ->
      Enum.filter(l, &(rem(&1, 2) == 0))
        |> List.foldl(0, fn elem, acc -> :timer.sleep(2000)
                          elem + acc
                        end)
        |> IO.puts()
      end)
    pid_odds = spawn(fn ->
      Enum.filter(l, &(rem(&1, 2) != 0))
        |> List.foldl(0, &+/2)
        |> IO.puts()
      end)
      {pid_even, pid_odds}
  end
end
