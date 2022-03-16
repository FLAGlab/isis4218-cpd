defmodule HelloActor do
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
