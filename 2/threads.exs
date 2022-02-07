defmodule Threads do

  def proc1 do
    1..5 |> Enum.map(&adder(&1, 0))
  end
  def adder(num, acc) do
    :timer.sleep(2000)
    "sum is #{acc + num}"
  end


  def proc2 do
    adder2 = fn (num, acc) ->
      :timer.sleep(2000)
      "sum is #{acc + num}"
    end
    asynch_adder = fn(num, acc) ->
      spawn(fn -> IO.puts(adder2.(num, acc)) end)
    end
    Enum.each(1..5, &asynch_adder.(&1, 0))
  end


  def proc3 do
    #calling the exterlan method from within the process serializes de execution
    asynch_adder = fn(num, acc) ->
      spawn(fn -> IO.puts(adder(num, acc)) end)
    end
    Enum.each(1..5, &asynch_adder.(&1, 0))
  end


  def proc4 do
    adder2 = fn (num, acc) ->
      :timer.sleep(2000)
      "sum is #{acc + num}"
    end
    asynch_adder = fn(num, acc) ->
      caller = self
      spawn(fn ->
        send(caller, {:sum_res, adder2.(num, acc)})
      end)
    end
    get_res = fn ->
      receive do
        {:sum_res, result} -> result
      end
    end
    1..5
     |> Enum.map(&asynch_adder.(&1, 0))
     |> Enum.map(fn _ -> get_res.() end)
  end
end
