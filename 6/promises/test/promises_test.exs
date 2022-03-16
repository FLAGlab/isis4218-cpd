defmodule PromiseTest do
  use ExUnit.Case
  doctest Promise

  test "greets the world" do
    assert Promise.hello() == :world
  end
end
