defmodule Ex do
  def map(l, fun) do
    l
      |> Enum.map(&process_map(&1, fun))
      |> Enum.map(fn x -> IO.puts "return from process #{inspect(x)}" end)
  end

  defp process_map(elem, fun) do
    spawn (fn ->
      :timer.sleep(5000)
      IO.puts "processing in process #{inspect(self())} with value #{fun.(elem)}"
    end)
  end

  def odds_even(l) do
    odds = Enum.filter(l, &(rem(&1, 2) != 0))
    even = Enum.filter(l, &(rem(&1, 2) == 0))
    spawn(fn -> IO.puts List.foldl(odds, 0, &+/2) end)
    spawn(fn -> IO.puts List.foldl(even, 0, &+/2) end)
  end

  def main do
    say_something = fn(time) ->
      IO.puts "I say #{time}"
      Process.sleep(1000)
      IO.puts "The #{time} time"
      Process.sleep(1000)
    end
    spawn(fn -> say_something.("First") end)
    spawn(fn -> say_something.("Second") end)
    spawn(fn -> say_something.("Third") end)
  end

  def order do
    spawn(fn -> IO.puts "Reading record First from the database"
      #:timer.sleep(250)
      IO.puts "Saving record First to the database"
      :timer.sleep(250)
    end)
    spawn(fn -> IO.puts "Reading record Second from the database"
      #:timer.sleep(250)
      IO.puts "Saving record Second to the database"
      :timer.sleep(250)
    end)
    spawn(fn -> IO.puts "Reading record Third from the database"
      #:timer.sleep(250)
      IO.puts "Saving record Third to the database"
      :timer.sleep(250)
    end)
  end

  def main2 do
    Enum.each(1..20, fn elem ->
      spawn(fn -> :timer.sleep(1000)
      IO.puts "#{elem}" end) end)
  end

  def main3 do
    count = 0
    increment = fn _ -> count + 1 end
    spawn(fn ->
        Enum.each(1..10000, fn _ -> count = increment.(count) end)
    end)
    spawn(fn ->
        Enum.each(1..10000, fn _ -> count = increment.(count) end)
    end)
    IO.puts count
  end

  defp while(0) do
      IO.puts "Iterating infinitely"
      while(0)
  end
  def process_exits do
    pid = spawn(fn -> while(0) end)
    Process.sleep(200)
    Process.exit(pid, :ok)
  end
end
