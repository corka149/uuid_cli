defmodule UuidCliTest do
  use ExUnit.Case
  doctest UuidCli

  test "greets the world" do
    assert UuidCli.hello() == :world
  end
end
