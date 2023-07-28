defmodule Todo.Server do
  use Agent, restart: :temporary

  @type name() :: binary()
  @type entry_id() :: integer()
  @type in_entry() :: %{ title: binary(),
                         date: Calendar.date() }
  @type out_entry() :: %{ id: entry_id(),
                          title: binary(),
                          date: Calendar.date() }

  @spec start_link(name()) :: {:ok, pid()}
  def start_link(name) do
    Agent.start_link(
      fn ->
        IO.puts("Starting to-do server for #{name}")
        {name, Todo.Database.get(name) || Todo.List.new()}
      end,
      name: via_tuple(name)
    )
  end

  @spec add_entry(pid(), in_entry()) :: no_return()
  def add_entry(server, entry) do
    Agent.cast(server, fn {name, todo_list} ->
      todo_list = Todo.List.add_entry(todo_list, entry)
      Todo.Database.store(name, todo_list)
      {name, todo_list}
    end)
  end

  @spec entries(pid(), Calenar.date()) :: [out_entry()]
  def entries(server, date) do
    Agent.get(server, fn {_name, todo_list} ->
      Todo.List.entries(todo_list, date)
    end)
  end

  @spec delete_entry(pid(), entry_id()) :: no_return()
  def delete_entry(server, id) do
    Agent.cast(server, fn {name, todo_list} ->
      todo_list = Todo.List.delete_entry(todo_list, id)
      {name, todo_list}
    end)
  end

  # Internal Functions
  defp via_tuple(name) do
    Todo.ProcessRegistry.via_tuple({__MODULE__, name})
  end
end
