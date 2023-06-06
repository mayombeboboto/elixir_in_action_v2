defmodule Todo.Server do
  use GenServer
  @type entry_id() :: integer()
  @type in_entry() :: %{ title: binary(),
                         date: Calendar.date() }
  @type out_entry() :: %{ id: entry_id(),
                          title: binary(),
                          date: Calendar.date() }

  @spec start_link() :: {:ok, pid()}
  def start_link() do
    GenServer.start_link( __MODULE__, nil)
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

  @impl true
  def init(nil) do
    {:ok, Todo.List.new()}
  end

  @impl true
  def handle_call({:entries, date}, _from, state) do
    {:reply, Todo.List.entries(state, date), state}
  end

  @impl true
  def handle_cast({:add_entry, entry}, state) do
    {:noreply, Todo.List.add_entry(state, entry)}
  end

  def handle_cast({:delete_entry, id}, state) do
    {:noreply, Todo.List.delete_entry(state, id)}
  end

  @impl true
  def handle_info(_info, state) do
    {:noreply, state}
  end

  @impl true
  def terminate(reason, _state) do
    IO.puts("Server terminating with reason: #{inspect(reason)}")
  end
end
