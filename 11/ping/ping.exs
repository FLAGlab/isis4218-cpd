defmodule Ping do
  def loop do
    receive do
      {:pong, name,  msg} -> IO.puts "pong #{msg}"
                  :global.whereis_name(name)
                    |> send({:ping, :pingnode, msg + 1})
                  loop()
    end
  end
end


#Use
#1. Load each part of the program on its own BEAM node
#2. create a process for the loop function spawn(Module, :function, [params])
#3. Connect the nodes Node.connect(:name@location)
#4. register the process to the global registry (:global.register_name(name, pid))
#5. find the process and call it using npid = :global.whereis_name(name)
#6. send(npid, {params})
