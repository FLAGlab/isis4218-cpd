defmodule HelloActor do
  def loop() do
    receive do
      {:hello, msg} -> IO.inspect "Hello #{msg}"
      {:hola, msg} -> IO.inspect "Hola, #{msg}!"
      #{:link, pid} -> Process.link(pid)
      {:shutdown, reason} -> exit(reason)
      _ -> IO.puts "Sorry I don't seem to understand that"
    end
    loop()
  end









  def loop2 do
    receive do
      {:hello, msg} -> :timer.sleep(5000);  IO.puts "Hello #{msg}"
      _ -> IO.puts "Sorry I don't seem to understand that"
    end
    loop2()
  end



  def loop3(greeters) do
    receive do
      {:hello, msg} -> IO.puts "Hello #{msg}"
        loop3([msg | greeters])
      {:hola, msg} -> IO.puts "Hola, #{msg}!"
        loop3([msg | greeters])
      {:shutdown} -> exit(:normal)
      {:greeters} -> IO.puts greeters
        loop3(greeters)
      _ -> IO.puts "Sorry I don't understand that"
        loop3(greeters)
   end
  end

end


defmodule DoubleActor do
  def rec1 do
    receive do
      {:foo, msg} -> foo(msg)
    end
    rec2()
  end

  def rec2 do
    receive do
      {:bar, msg} -> bar(msg)
    end
    rec1()
  end

  def foo(msg) do
    IO.puts "foo "<>msg
  end

  def bar(msg) do
    IO.puts "bar "<>msg
  end
end


defmodule Actor do
  def loop() do
    receive do
      {:hello, msg} -> IO.puts msg
      {:a, msg} -> skip
    end
    loop()
  end
end

defmodule Drown do
  def main() do
    actor  = spawn(&HelloActor.loop/0)
    for i <- 1..1_000_000, do: send actor, {:hello, "message #{i}"}
  end

  def main2() do
    actor  = spawn(&HelloActor.loop2/0)
    for i <- 1..1_000_000_000_000, do: send actor, {:hello, "message #{i}"}
  end

  def main3() do
    actor  = spawn(&Actor.loop/0)
    for i <- 1..1_000_000_000_000, do: send actor, {:a, "message #{i}"}
    send actor, {:hello, "world"}
  end

  def main4() do
    actor = spawn(fn -> HelloActor.loop([]) end)
    send actor, {:hello, "Me"}
    send actor, {:hola, "Nicolas"}
    send actor, {:greeters}
    send actor, {:shutdown}
  end

  def main5() do
    actor  = spawn(&HelloActor.loop/0)
    spawn(fn -> for i <- 1..1_000_000, do: send actor, {:a, "message #{i}"} end)
    send actor, {:hello, "world"}
  end
end


defmodule HelloActorLink do
  def link_process() do
    Process.flag(:trap_exit, true)
    loop()
  end

  def loop() do
      receive do
        {:hello, msg} -> IO.puts "Hello #{msg}"
        {:link_to, pid} -> Process.link(pid)
        {:shutdown, reason} -> exit(reason)
        {:EXIT, pid, reason} -> IO.puts "#{inspect pid} exited because #{reason} happened"
    end
      loop()
  end
end
