defmodule Counter do
  use Agent
  @count COUNTER

  def start_link do
    Agent.start_link(fn -> 0 end, name: @count)
  end

  def inc do
    Agent.update(@count, &(&1 + 1))
  end

  def count do
    Agent.get(@count, &(&1))
  end
end


defmodule A do
  @name __MODULE__
  def start_link do
    Agent.start_link(fn -> %{} end, name: @name)
  end

  def add_player(id) do
    Agent.update(@name, fn map -> Map.update(map, id, id, &(&1)) end)
  end

  def diplay_registered_players do
    Agent.get(@name, &Map.values(&1))
      |> Enum.map(fn player -> IO.puts "Player: #{player}" end)
  end
end
