defmodule TodoListTest do
  use ExUnit.Case
  doctest TodoList

  test "into TodoList" do
    entries = TodoUtils.get_entries()
    assert TodoList.new() == Enum.into(entries, TodoList.new([]))
  end

  test "TodoList to string" do
    assert :ok == TodoList.new() |> IO.puts()
  end
end
