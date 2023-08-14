defmodule TodoWebTest do
  use ExUnit.Case
  doctest TodoWeb

  test "greets the world" do
    assert TodoWeb.hello() == :world
  end
end
