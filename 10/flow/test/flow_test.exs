defmodule WordCountTest do
  use ExUnit.Case
  doctest WordCount

  test "greets the world" do
    assert WordCount.hello() == :world
  end
end
