defmodule Messaging do

    def play_with_queue do
        receive do
            {:msg2, msg} -> 
                IO.puts "Message 2 #{msg}"
                play_with_queue()
            {:msg4, msg} ->
                IO.puts "Message 4 #{msg}"
                play_with_queue()
        end
    end

    def run do 
        p = spawn(Messaging, :play_with_queue, [])
        send p, {:msg1, "First message"}
        send p, {:msg2, "Second message"}
        send p, {:msg3, "Third message"}
        send p, {:msg4, "Fourth message"}
    end
end