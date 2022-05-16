defmodule MapReduceTest do
  use ExUnit.Case
  doctest MapReduce

  test "greets the world" do
    assert MapReduce.hello() == :world
  end
end
