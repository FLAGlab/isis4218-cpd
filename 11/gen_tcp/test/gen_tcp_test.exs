defmodule GenTcpTest do
  use ExUnit.Case
  doctest GenTcp

  test "greets the world" do
    assert GenTcp.hello() == :world
  end
end
