defmodule PubSubTest do
  use ExUnit.Case
  doctest PubSub

  test "greets the world" do
    assert PubSub.hello() == :world
  end
end
