defmodule GameServer do
  @name __MODULE__
  def start_link, do: Agent.start_link(fn -> %{} end, name: @name)
  def stop, do: Agent.stop(@name)

  def create_player(player_name) do
    task = Task.async(fn ->
      Agent.update(@name, &join_player(&1, player_name)) end)
    Task.await(task)
    get_players()
  end
  def get_players do
    Agent.get(@name, &display_player(&1))
  end

  defp join_player(players, player_name) do
    Map.update(players, player_name, player_name, &(&1))
  end

  defp display_player(players) do
    Map.values(players)
      |> Enum.map(&(IO.puts "Player name: #{&1}"))
  end
end

defmodule GameServer2 do
  @name __MODULE__
  def start_link, do: Agent.start_link(fn -> %{} end, name: @name)
  def stop, do: Agent.stop(@name)

  def create_player(player_name) do
    task = Task.async(fn ->
      Process.sleep(5000)
      Agent.update(@name, &join_player(&1, player_name)) end)
  end
  def get_players do
    Agent.get(@name, &display_player(&1))
  end

  defp join_player(players, player_name) do
    Map.update(players, player_name, player_name, &(&1))
  end

  defp display_player(players) do
    Map.values(players)
      |> Enum.map(&(IO.puts "Player name: #{&1}"))
  end
end
