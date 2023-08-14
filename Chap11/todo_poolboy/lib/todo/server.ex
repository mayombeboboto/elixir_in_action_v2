defmodule Todo.Server do
  use GenServer, restart: :temporary

  @type name() :: binary()
  @type entry_id() :: integer()
  @type in_entry() :: %{ title: binary(),
                         date: Calendar.date() }
  @type out_entry() :: %{ id: entry_id(),
                          title: binary(),
                          date: Calendar.date() }

  # APIs
  @spec start_link(name()) :: {:ok, pid()}
  def start_link(todo_list_name) do
    IO.puts("Starting database server.")
    GenServer.start_link(
      __MODULE__,
      todo_list_name,
      name: via_tuple(todo_list_name)
    )
  end

  @spec add_entry(pid(), in_entry()) :: no_return()
  def add_entry(server, entry) do
    GenServer.cast(server, {:add_entry, entry})
  end

  @spec entries(pid(), Calendar.date()) :: [out_entry()]
  def entries(server, date) do
    GenServer.call(server, {:entries, date})
  end

  @spec delete_entry(pid(), entry_id()) :: no_return()
  def delete_entry(server, id) do
    GenServer.cast(server, {:delete_entry, id})
  end

  # Callback Functions
  @impl true
  def init(todo_list_name) do
    todo_list = Todo.Database.get(todo_list_name) || Todo.List.new()
    {:ok, {todo_list_name, todo_list}}
  end

  @impl true
  def handle_call({:entries, date}, _from, {todo_list_name, todo_list}) do
    {:reply, Todo.List.entries(todo_list, date), {todo_list_name, todo_list}}
  end

  @impl true
  def handle_cast({:add_entry, entry}, {todo_list_name, todo_list}) do
    todo_list = Todo.List.add_entry(todo_list, entry)
    Todo.Database.store(todo_list_name, todo_list)
    {:noreply, {todo_list_name, todo_list}}
  end

  def handle_cast({:delete_entry, id}, {todo_list_name, todo_list}) do
    todo_list = Todo.List.delete_entry(todo_list, id)
    {:noreply, {todo_list_name, todo_list}}
  end

  @impl true
  def handle_info(_info, state) do
    {:noreply, state}
  end

  @impl true
  def terminate(reason, _state) do
    IO.puts("Server terminating with reason: #{inspect(reason)}")
  end

  # Internal Functions
  defp via_tuple(name) do
    Todo.ProcessRegistry.via_tuple({__MODULE__, name})
  end
end
