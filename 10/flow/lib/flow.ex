defmodule WordCount do
  @moduledoc """
  Documentation for WordCount.
  """

  @doc """
  Hello world.

  ## Examples

      iex> WordCount.hello()
      :world

  """
  def flow do
    File.stream!("test/input", :line)
      |> Flow.from_enumerable()
      |> Flow.flat_map(&String.split/1)
      |> Flow.partition()
      |> Flow.reduce(%{}, fn word, map -> count(word, map) end)
      |> Enum.into(%{})
  end

  defp count(word, map) do
    Map.update(map, word, 1, &(&1 + 1))
  end
end
