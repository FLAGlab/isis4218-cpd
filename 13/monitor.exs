defmodule Monitor do
  def monitor() do
    Process.flag(:trap_exit, true)
    pid = spawn(fn -> :timer.sleep 500
        raise("Monitor not-Error")
      end)
    ref = Process.monitor(pid)
    receive do
      {:DOWN, ^ref, :process, ^pid, reason} -> IO.puts "Exit #{inspect pid} because #{inspect reason}"
    end
  end

  def links() do
    Process.flag(:trap_exit, true)
    pid = spawn(fn -> :timer.sleep 500
        raise(" Link Error")
      end)
    Process.link(pid)
    receive do
      {:EXIT, pid, reason} -> IO.puts "Killing process from #{inspect pid} because #{inspect reason}"
    end
  end
end
