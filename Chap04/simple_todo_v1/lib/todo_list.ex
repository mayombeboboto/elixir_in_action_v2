defmodule TodoList do
  @moduledoc """
  Documentation for `TodoList`.
  """

  def new(), do: %{}

  def add_entry(todo_list, entry=%{ date: date }) do
    Map.update(todo_list, date, [entry], &([entry|&1]))
  end

  def entries(todo_list, date) do
    Map.get(todo_list, date, [])
  end
end
