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
    Enum.map(1..4, &"words/list#{&1}")
      |> load_from_files()
      |> Enum.flat_map(&String.split/1)
      |> Enum.reduce(%{}, fn word, map -> count(word, map) end)
  end

  def count_vowels(list) when length(list) < 100 do
    list
     |> Enum.reduce(%{}, fn word, map -> count(word, map) end)
  end
  def count_vowels(list) do
    {left, right}  = Enum.split(list, div(length(list), 2))
    lp = Task.async(fn -> count_vowels(left) end)
    r_map = count_vowels(right)
    Task.await(lp)
     |> Enum.reduce(r_map, fn {k, v}, map -> Map.update(map, k, v, &(&1 + v)) end)
  end

  defp count(word, map) do
    vowels = ["A", "E", "I", "O", "U", "a", "e", "i", "o", "u", "y", "Y"]
    if Enum.member?(vowels, word) do
      Map.update(map, word, 1, &(&1 + 1))
    else map end
  end
end
