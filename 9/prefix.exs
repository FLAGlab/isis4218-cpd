defmodule PrefixSum do
  @arr Enum.to_list(1..100_000)
  @list [6,4,16,10,16,14,2,8]
  def seq_prefix_sum do
    do_seq_prefix_sum(@arr, [])
  end

  defp do_seq_prefix_sum([h|t], []), do: do_seq_prefix_sum(t, [h])
  defp do_seq_prefix_sum([], out), do: Enum.reverse(out)
  defp do_seq_prefix_sum([h|t], [h_out|tail_out]) do
    do_seq_prefix_sum(t, [h_out + h | [h_out | tail_out]])
  end

  def prefix_sum do
    build_tree(@list, 0, length(@list))
     |> from_left()
     |> out_sum()
  end

  defp build_tree([h | []], low, high), do: %{:range => {low,high}, :sum => h, :from_left => -1, :left => :leaf, :right => :leaf }
  defp build_tree(list, low, high) do
    mid = div(length(list), 2)
    {left, right} = Enum.split(list, mid)
    lp = Task.async(fn -> build_tree(left, low, mid + low) end)
    ans_r = build_tree(right, mid + low, high)
    lt = Task.await(lp)
    %{:range => {low, high},
      :sum => Map.get(ans_r, :sum) + Map.get(lt, :sum),
      :from_left => -1,
      :right => ans_r,
      :left => lt}
  end

  defp from_left(tree) do
    Map.update(tree, :from_left, 0, fn _ -> 0 end)
     |> do_from_left(0)
  end
  defp do_from_left(:leaf, _), do: :leaf
  defp do_from_left(%{:from_left => fl, :left => :leaf, :range => r, :right => :leaf, :sum => s}, _) do
    %{:from_left => fl, :left => :leaf, :range => r, :right => :leaf, :sum => s}
  end
  defp do_from_left(tree, from_left) do
    IO.inspect(tree)
    ls = Map.get(tree, :left)
    rs = Map.get(tree, :right)
    grand_son = Map.get(ls, :left)
    {ls, rs} = cond do
      not is_atom(grand_son) -> {ls, rs}
      true ->
        {
          Map.update(ls, :from_left, from_left, fn _ -> from_left end),
          Map.update(rs, :from_left, from_left + Map.get(ls, :sum), fn _ -> from_left + Map.get(ls, :sum) end)
        }
    end
    lp = Task.async(fn -> do_from_left(ls, from_left) end)
    rp = do_from_left(rs, from_left + Map.get(ls, :sum))
    %{:from_left => from_left, :left => Task.await(lp), :range => Map.get(tree, :range), :right => rp, :sum => Map.get(tree, :sum)}
  end

  def out_sum(tree), do: DFS.visit(tree, [])
end


defmodule DFS do
  def visit(%{from_left: from_left, left: left, range: _range, right: _right, sum: _sum}, _res) when is_atom(left) do
    [from_left]
  end
  def visit(tree, res) do
    left = visit(Map.get(tree, :left), res)
    right = visit(Map.get(tree, :right), res)
    left ++ right ++ res
  end
end
