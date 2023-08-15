defmodule TodoEnvTest do
  use ExUnit.Case
  doctest TodoEnv

  test "greets the world" do
    assert TodoEnv.hello() == :world
  end
end
