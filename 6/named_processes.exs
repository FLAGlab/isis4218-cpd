defmodule Named do
  def register(name) do
    Process.register(self(), :"#{name}")
  end
  
  def loop do
    receive do
      {:register, name} -> register(name)
      {:message, m} -> IO.puts m
    end
    loop()
  end
end
