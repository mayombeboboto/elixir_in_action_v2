defmodule TodoPoolboyTest do
  use ExUnit.Case
  doctest TodoPoolboy

  test "greets the world" do
    assert TodoPoolboy.hello() == :world
  end
end
