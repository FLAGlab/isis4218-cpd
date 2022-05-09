defmodule ChatclientTest do
  use ExUnit.Case
  doctest Chatclient

  test "greets the world" do
    assert Chatclient.hello() == :world
  end
end
