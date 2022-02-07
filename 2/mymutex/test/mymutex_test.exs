defmodule MyMutexTest do
  use ExUnit.Case
  doctest MyMutex

  test "greets the world" do
    assert MyMutex.hello() == :world
  end
end
