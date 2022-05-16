defmodule Merge do
  def merge([]), do: []
  def merge(list), do: split(list)

  defp split([]), do: []
  defp split([h|[]]), do: [h]
  defp split(list) do
    mid = div length(list), 2
    take = Enum.slice(list, 0..mid - 1)
    drop = Enum.drop(list, mid)
    sort(split(take), split(drop))
  end

  defp sort([], []), do: []
  defp sort([], list), do: list
  defp sort(list, []), do: list
  defp sort(l1, l2), do: do_sort(l1, l2, [])
  defp do_sort([], [], acc), do: Enum.reverse acc
  defp do_sort([], [h|t], acc), do: do_sort([], t, [h | acc])
  defp do_sort([h|t], [], acc), do: do_sort(t, [], [h | acc])
  defp do_sort([h|t], [h2 | t2], acc) when h < h2 do
    do_sort(t, [h2 | t2], [h | acc])
  end
  defp do_sort([h|t], [h2 | t2], acc) do
    do_sort([h|t], t2, [h2 | acc])
  end
end








defmodule PMerge do
  def merge(list), do: split(list)

  defp split([]), do: []
  defp split([h|[]]), do: [h]
  defp split(list) do
    mid = div length(list), 2
    take = Enum.slice(list, 0..mid - 1)
    drop = Enum.drop(list, mid)
    t_pid = Task.async(fn -> split(take) end)
    d_pid = Task.async(fn -> split(drop) end)
    sort(Task.await(t_pid), Task.await(d_pid))
  end

  defp sort([], []), do: []
  defp sort([], list), do: list
  defp sort(list, []), do: list
  defp sort(l1, l2), do: do_sort(l1, l2, [])
  defp do_sort([], [], acc), do: Enum.reverse acc
  defp do_sort([], [h|t], acc), do: do_sort([], t, [h | acc])
  defp do_sort([h|t], [], acc), do: do_sort(t, [], [h | acc])
  defp do_sort([h|t], [h2 | t2], acc) when h < h2 do
    do_sort(t, [h2 | t2], [h | acc])
  end
  defp do_sort([h|t], [h2 | t2], acc) do
    do_sort([h|t], t2, [h2 | acc])  
  end
end








defmodule PMerge2 do
  def merge(list) when length(list) < 2, do: list
  def merge(list), do: split(list)

  defp split(list) when length(list) < 2, do: list
  defp split(list) do
    mid = div length(list), 2
    {left, right} = Enum.split(list, mid)
    t_pid = Task.async(fn -> split(left) end)
    d_pid = Task.async(fn -> split(right) end)
    sort(Task.await(t_pid), Task.await(d_pid))
  end

  defp sort([], []), do: []
  defp sort([], list), do: list
  defp sort(list, []), do: list
  defp sort(l1, l2), do: do_sort(l1, l2, [])
  defp do_sort([], [], acc), do: Enum.reverse acc
  defp do_sort([], [h|t], acc), do: do_sort([], t, [h | acc])
  defp do_sort([h|t], [], acc), do: do_sort(t, [], [h | acc])
  defp do_sort([h|t], [h2 | t2], acc) when h < h2 do
    do_sort(t, [h2 | t2], [h | acc])
  end
  defp do_sort([h|t], [h2 | t2], acc) do
    do_sort([h|t], t2, [h2 | acc])
  end
end
