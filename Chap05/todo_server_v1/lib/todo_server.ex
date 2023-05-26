defmodule TodoServer do
  @moduledoc """
  Documentation for `TodoServer`.
  """
  @type entry_id() :: integer()
  @type in_entry() :: %{ title: binary(),
                         date: Calendar.date() }
  @type out_entry() :: %{ id: entry_id(),
                          title: binary(),
                          date: Calendar.date() }

  # APIs
  @spec start() :: pid()
  def start do
    spawn(fn -> loop(TodoList.new()) end)
  end

  @spec add_entry(pid(), in_entry()) :: no_return()
  def add_entry(todo_server, new_entry) do
    send(todo_server, {:add_entry, new_entry})
  end

  @spec entries(pid(), Calendar.date()) :: [out_entry()]
  def entries(todo_server, date) do
    send(todo_server, {:entries, self(), date})

    receive do
      {:todo_entries, entries} ->
        entries
      after 5000 ->
        {:error, :timeout}
    end
  end

  @spec delete_entry(pid(), entry_id()) :: no_return()
  def delete_entry(todo_server, id) do
    send(todo_server, {:delete_entry, id})
  end

  # Internal Functions
  defp loop(todo_list) do
    new_todo_list =
      receive do
        message -> process_message(todo_list, message)
      end
    loop(new_todo_list)
  end

  defp process_message(todo_list, {:add_entry, new_entry}) do
    TodoList.add_entry(todo_list, new_entry)
  end

  defp process_message(todo_list, {:entries, caller, date}) do
    entries = TodoList.entries(todo_list, date)
    send(caller, {:todo_entries, entries})
    todo_list
  end

  defp process_message(todo_list, {:delete_entry, id}) do
    TodoList.delete_entry(todo_list, id)
  end
end
