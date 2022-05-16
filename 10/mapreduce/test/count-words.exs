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

  def main do
    map = %{}
    Enum.map(1..4, &"words/list#{&1}")
      |> load_from_files()
      |> Enum.flat_map(&String.split/1)
      |> Enum.reduce(%{}, fn word, map -> count(word, map) end)
  end

  def count_vowels(list) when length(list) < 100 do
    map = %{}
    list
     |> Enum.reduce(%{}, fn word, map -> count(word, map) end)
  end
  def count_vowels(list) do
    map = %{}
    {left, right}  = Enum.split(list, div(length(list), 2))
    lp = Task.async(fn -> count_vowels(left) end)
    r_map = count_vowels(right)
    Task.await(lp)
     |> Enum.reduce(map, fn {k, v}, map -> Map.update(map, k, v, &(&1 + v)) end)
  end

  defp count(word, map) do
    vowels = ["A", "E", "I", "O", "U", "a", "e", "i", "o", "u", "y", "Y"]
    if vowels.contains(String.first(word)) do
      Map.update(map, String.first(word), 1, &(&1 + 1))
    end
  end
end
