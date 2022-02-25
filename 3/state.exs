defmodule Test do
  def update(var) do
    Process.put(:c, var)
    #update(var)
  end

  def main do
    pid = spawn(fn ->
      x = :rand.uniform(20)
      update(x)
    end)
    :timer.sleep(5000)
    Process.monitor(pid)
    |> Process.get(:c)    
    |> IO.puts

  end
end
