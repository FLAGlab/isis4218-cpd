defmodule Named do
  def loop do
    receive do
      {:directed} -> IO.puts "Message directed to actor #{inspect self()}"
    end
    loop()
  end
end
