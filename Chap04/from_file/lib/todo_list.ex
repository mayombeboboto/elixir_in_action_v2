defmodule TodoList do
  @moduledoc """
  Documentation for `TodoList`.
  """
  defstruct auto_id: 1, entries: %{}

  def new() do
    TodoUtils.get_entries()
    |> new()
  end

  def new(entries) do
    Enum.reduce(entries, %TodoList{}, &(add_entry(&2, &1)))
  end

  def add_entry(todo_list, entry) do
    entry = Map.put(entry, :id, todo_list.auto_id)
    new_entries = Map.put(
      todo_list.entries,
      todo_list.auto_id,
      entry
    )

    %TodoList{ todo_list |
      entries: new_entries,
      auto_id: todo_list.auto_id+1 }
  end

  def entries(todo_list, date) do
    todo_list.entries
    |> Stream.filter(fn {_entry_id, entry} -> entry.date == date end)
    |> Enum.map(fn {_entry_id, entry} -> entry end)
  end

  def update_entry(todo_list, %{} = new_entry) do
    update_entry(todo_list, new_entry.id, fn _entry -> new_entry end)
  end

  def update_entry(todo_list, entry_id, updater_fun) do
    case Map.fetch(todo_list.entries, entry_id) do
      :error ->
        todo_list
      {:ok, old_entry=%{ id: old_id }} ->
        new_entry = %{ id: ^old_id } = updater_fun.(old_entry)
        new_entries = Map.put(todo_list.entries, new_entry.id, new_entry)
        %TodoList{ todo_list | entries: new_entries }
    end
  end
end
