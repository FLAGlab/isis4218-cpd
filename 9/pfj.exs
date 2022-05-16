defmodule Pack do
  #@list for _ <- 1..100_000, do: :rand.uniform(1..100_000)
  @list [17,4,6,8,11,5,13,19,0,24]
  def test do
    pack(@list, fn x -> x > 10 end)
  end

  def pack([h | []], fun), do: if fun.(h), do: [h], else: []
  def pack(list, fun) do
    {left, right} = Enum.split(list, div(length(list), 2))
    l_pid = Task.async(fn ->  pack(left, fun) end)
    r_ans = pack(right, fun)
    Task.await(l_pid) ++ r_ans
  end
end
