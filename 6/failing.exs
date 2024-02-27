defmodule Fail do

  def loop() do
    receive do
      {:hello, msg} -> IO.puts "Hello #{msg}"
      {:link_to, pid} -> Process.link(pid)
      {:shutdown, reason} -> exit(reason)
      _ -> IO.puts "Sorry I don't understand that"
    end
    loop()
  end

  def test() do
    a1 = spawn(&Fail.loop/0)
    a2 = spawn(&Fail.loop/0)
    send a1, {:link_to, a2}
    send a2, {:shutdown, :bye}

    Process.alive?(a1)
    Process.alive?(a2)
  end
end

defmodule Fail1 do
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

  def test() do
    a1 = spawn(&Fail1.link_process/0)
    a2 = spawn(&Fail1.link_process/0)
    IO.puts "a1 = #{inspect a1}"
    IO.puts "a2 = #{inspect a2}"
    send a1, {:link_to, a2}
    send a1, {:shutdown, :bye}
    :timer.sleep(100)
    Process.info(a1, :status)
    Process.info(a2, :status)
  end

  def test2 do
    a1 = spawn(&Fail1.link_process/0)
    a2 = spawn(&Fail1.link_process/0)
    send a1, {:link_to, a2}
    send a2, {:shutdown, :normal}
    :timer.sleep(100)
    Process.info(a2, :status)
    Process.info(a1, :status)
  end
end
