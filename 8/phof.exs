defmodule PHOF do
  @cores  System.schedulers_online

  def pmap(list, fun) do
    list
     |> Enum.map(&Task.async(fn -> fun.(&1) end))
     |> Enum.map(&Task.await/1)
  end

  def weak_pfold(list, init, fun) do
    {left, right} = Enum.split(list, div(length(list), 2))
    l_fold = List.foldl(left, init, fun)
    r_fold = List.foldl(right, init, fun)
    fun.(l_fold, r_fold)
  end

  def pfold(arr, id, fun) do
    Tree.turn_to_tree(arr)
      |> Tree.reduce(id, fun)
    end

  def pmap_cores(list, fun) do
    Enum.chunk_every(list, div(length(list), @cores))
     |> Enum.map(&Task.async(fn -> Enum.map(&1, fn elem -> fun.(elem) end) end))
     |> Enum.map(&Task.await/1)
     |> List.flatten()
  end

  def pmap_link(list, fun) do
    me = self()
    list
     |> Enum.map(fn(elem) ->
       spawn_link(fn -> send(me, {self(), fun.(elem)}) end) end)
     |> Enum.map(fn(pid) ->
       receive do {^pid, res} -> res end end)
  end

  def bad_pfold(list, init, fun) do
    {left, right} = Enum.split(list, div(length(list), 2))
    l_fold = List.foldl(left, init, fun)
    r_fold = List.foldl(right, init, fun)
    fun.(l_fold, r_fold)
  end
end


defmodule Tree do
  def new(value) do
		%{value: value, left: :leaf, right: :leaf}
	end

	@doc """
	Creates and inserts a node with its value as 'node_value' into the tree.
	"""
	@spec insert(%{} | :leaf, any) :: %{}
	def insert(:leaf, node_value), do: new node_value
	def insert(%{value: value, left: left, right: right}, node_value) do
		if node_value < value do
			%{value: value, left: insert(left, node_value), right: right}
		else
			%{value: value, left: left, right: insert(right, node_value)}
		end
	end

  def reduce(t, id, fun) do
    case t do
      :leaf -> id
      %{value: v, left: l, right: r} ->
        lpid = Task.async(fn -> reduce(l, id, fun) end)
        rpid = Task.async(fn -> reduce(r, id, fun) end)
        fun.(v, fun.(Task.await(lpid), Task.await(rpid)))
    end
  end

  def treeify(l), do: turn_to_tree(l, :leaf)
  def turn_to_tree([], tree) do
    tree
  end
  def turn_to_tree([h|t], tree)  do
    turn_to_tree(t, insert(tree, h))
  end
end
