defmodule MyProcess do
    def start do
        accepting_messages(0)
    end

    def accepting_messages(state) do
        receive do
          {:hello, message} ->
            IO.puts "Hello, #{message}"
            accepting_messages(state)
        {:counter} ->
            new_state = state + 1
            IO.puts "New state is #{new_state}"
            accepting_messages(new_state)
        _ ->
            IO.puts "What?"
            accepting_messages(state)
        end  
    end
end