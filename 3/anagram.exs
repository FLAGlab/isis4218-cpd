defmodule Dictionary do
  @name __MODULE__
  def start_link, do: Agent.start_link(fn -> %{} end, name: @name)
  def add_words(words), do: Agent.update(@name, &do_add_words(&1, words))
  def anagrams_of(word) do
    Agent.get(@name, &Map.get(&1, signature_of(word)))
  end
  def get_all do
    Agent.get(@name, fn state -> state end)
  end

  defp do_add_words(map, words) do
    Enum.reduce(words, map, &add_one_word(&1, &2))
  end

  defp add_one_word(word, map) do
    Map.update(map, signature_of(word), [word], &[word | &1])
  end

  defp signature_of(word) do
    word
      |> to_charlist()
      |> Enum.sort()
      |> to_string()
  end
end

defmodule WordLoader do
  def load_from_files(file_names) do
    file_names
      |> Stream.map(fn name -> Task.async(fn -> load_file(name) end) end)
      |> Enum.map(&Task.await/1)
  end

  defp load_file(name) do
    File.stream!(name, [], :line)
      |> Enum.map(&String.trim/1)
      |> Dictionary.add_words()
  end

  def main do
    Dictionary.start_link
    Enum.map(1..4, &"words/list#{&1}")
      |> load_from_files()
  end
end
