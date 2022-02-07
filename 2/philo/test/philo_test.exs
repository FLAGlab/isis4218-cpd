defmodule PhilosophersTest do
  use ExUnit.Case
  doctest Philosophers

  test "greets the world" do
    assert Philosophers.hello() == :world
  end
end
