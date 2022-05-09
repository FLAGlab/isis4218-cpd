defmodule Ping do
  def loop do
    receive do
      {:pong} -> IO.puts "ping"
                  :global.whereis_name(:pong)
                    |> send({:ping})
                  loop()
    end
  end
end


#Use
#1. Load each part of the program on it own BEAM node
#2. create a process for the loop function
#3. register the process to the global registry (:global.register_name(name, pid))
#4. find the process and call it using npid = :global.whereis_name(name)
#5. send(npid, {params})
