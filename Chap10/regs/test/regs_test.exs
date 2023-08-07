defmodule RegsTest do
  use ExUnit.Case
  doctest Regs

  test "register process" do
    {:ok, _regs} = Regs.Server.start_link()
    {:ok, pid} = Test.Utils.start_link()

    assert Test.Utils.register(pid, :some_key) == {:ok, :success}
    assert Test.Utils.register(pid, :some_key) == {:error, :duplicate}
    assert Regs.Server.whereis(:some_key) == pid
  end

  test "dead process" do
    {:ok, _regs} = Regs.Server.start_link()
    {:ok, pid} = Test.Utils.start_link()

    Test.Utils.register(pid, :some_key)
    Test.Utils.stop(pid)

    assert Regs.Server.whereis(:some_key) == nil
  end
end
