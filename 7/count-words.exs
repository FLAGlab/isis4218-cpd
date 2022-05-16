defmodule WordCounter do
  def load_from_files(file_names) do
    file_names
      |> Stream.map(fn name -> Task.async(fn -> load_file(name) end) end)
      |> Enum.map(&Task.await/1)
  end

  defp load_file(name) do
    File.stream!(name, [], :line)
      |> Enum.map(&String.trim/1)
  end

  def main do
    map = %{}
    Enum.map(1..4, &"words/list#{&1}")
      |> load_from_files()
      |> Enum.flat_map(fn elem -> Enum.map(elem, &String.split(&1)) end)
      |> Enum.map(&frequencies(&1, map))
      |> reduce_map(%{})
  end

  defp reduce_map([], acc), do: acc
  defp reduce_map([h | t], acc) do
    reduce_map(t, do_reduce(h, acc))
  end

  defp do_reduce(map, acc) do
    Map.keys(map)
    |> List.foldl(acc, fn k, acc ->
         acc = case Map.get(acc, k) do
             nil -> Map.put(acc, k, Map.get(map, k))
             v -> Map.put(acc, k, Map.get(map, k) + v)
         end
       end)
  end

  def frequencies(word_list, map) do
    count(word_list, map)
  end

  defp count([], map), do: map
  defp count([h | t], map) do
    count(t,  Map.update(map, h, 1, &(&1 + 1)))
  end
end


defmodule PWordCount do
  
end
