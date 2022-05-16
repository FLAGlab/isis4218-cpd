defmodule Splitter do
  def split(collection, _opts \\ System.schedulers_online), do:
    do_split([collection], 0, 1, System.schedulers_online*2)

  defp do_split(fragments, count, count, _n), do: fragments
  defp do_split(fragments, _, count, n) when count >= n, do: fragments
  defp do_split(fragments, _prev_count, count, n) do
    new_splitters = fragments
  	 |> Enum.reduce([], &split_reducer/2)
  	 |> Enum.reverse()
    new_count = Enum.count(new_splitters)
    do_split new_splitters, count, new_count, n
  end

  defp split_reducer(fragment, accum) when is_list(fragment) do
    fragment ++ accum
  end
  defp split_reducer(fragment, accum), do: [fragment | accum ]

  def split_fold(collection, acc, fun) do
    split(collection)
      |> Enum.map(fn e -> Task.async(fn -> fun.(e,acc) end) end)
  end
end
