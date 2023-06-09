defmodule Todo.Cache do
  use GenServer
  # APIs
  @spec start_link() :: {:ok, pid()}
  def start_link() do
    GenServer.start_link(__MODULE__, nil)
  end

  @spec server_process(pid(), binary()) :: pid()
  def server_process(cache_pid, todo_list_name) do
    GenServer.call(cache_pid, {:server_process, todo_list_name})
  end

  # Callback Functions
  @impl GenServer
  def init(_args) do
    Todo.Database.start_link()
    {:ok, %{}}
  end

  @impl GenServer
  def handle_call({:server_process, todo_list_name}, _from, todo_servers) do
    case Map.fetch(todo_servers, todo_list_name) do
      {:ok, todo_server} ->
        {:reply, todo_server, todo_servers}
      :error ->
        {:ok, new_server} = Todo.Server.start_link(todo_list_name)
        todo_servers = Map.put(todo_servers, todo_list_name, new_server)
        {:reply, new_server, todo_servers}
    end
  end

  @impl GenServer
  def handle_info(_info, todo_servers) do
    {:noreply, todo_servers}
  end

  @impl GenServer
  def terminate(_reason, _todo_servers) do
    :ok
  end

end
