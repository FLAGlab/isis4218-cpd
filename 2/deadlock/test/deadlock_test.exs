defmodule DeadlockTest do
  use ExUnit.Case
  doctest Deadlock

  test "greets the world" do
    assert Deadlock.hello() == :world
  end
end
