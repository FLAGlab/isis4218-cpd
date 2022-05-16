
#WordCounter.count_vowels(["hello", "world", "this", "is", "a", "long", "list", "of", "words", "without", "us","hello", "world", "this", "is", "a", "long", "list", "of", "words", "without", "us","hello", "world", "this", "is", "a", "long", "list", "of", "words", "without", "us","hello", "world", "this", "is", "a", "long", "list", "of", "words", "without", "us","hello", "world", "this", "is", "a", "long", "list", "of", "words", "without", "us","hello", "world", "this", "is", "a", "long", "list", "of", "words", "without", "us","hello", "world", "this", "is", "a", "long", "list", "of", "words", "without", "us","hello", "world", "this", "is", "a", "long", "list", "of", "words", "without", "us","hello", "world", "this", "is", "a", "long", "list", "of", "words", "without", "us","hello", "world", "this", "is", "a", "long", "list", "of", "words", "without", "us"])





defmodule Ex do
  @l Enum.to_list(1..100_000)
  def sum, do: sum_rec(@l)

  def sum_rec(list) when length(list) < 1000 do
    List.foldl(list, 0, fn x, acc -> x + acc end)
  end
  def sum_rec(list) do
    {l1, l2, l3,  l4} = Enum.split(list, div(length(list), 4))
    pid_l1 = Task.async(fn -> sum_rec(l1) end)
    pid_l2 = Task.async(fn -> sum_rec(l2) end)
    pid_l3 = Task.async(fn -> sum_rec(l3) end)
    sum_rec(l4) + Task.await(pid_l1) + Task.await(pid_l2) + Task.await(pid_l3)
  end


end
