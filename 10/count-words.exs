defmodule WordCounter do
  def load_from_files(file_names) do
    file_names
      |> Stream.map(fn name -> Task.async(fn -> load_file(name) end) end)
      |> Enum.flat_map(&Task.await/1)
  end

  defp load_file(name) do
    File.stream!(name, [], :line)
      |> Enum.map(&String.trim/1)
  end

  def seq do
    Enum.map(1..5, &"words/list#{&1}")
      |> load_from_files()
      |> Enum.flat_map(&String.split/1)
      |> Enum.reduce(%{}, fn word, map -> count(word, map) end)
  end

  defp count(word, map) do
    Map.update(map, word, 1, &(&1 + 1))
  end
end
