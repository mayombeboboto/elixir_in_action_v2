defmodule Todo.Database do
  use GenServer

  @db_folder "./persist"
  @type key() :: term()
  @type value() :: term()

  # APIs
  @spec start_link() :: {:ok, pid()}
  def start_link() do
    GenServer.start_link(
      __MODULE__,
      nil,
      name: __MODULE__
    )
  end

  @spec get(key()) :: value()
  def get(key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  @spec store(key(), value()) :: no_return()
  def store(key, data) do
    GenServer.cast(__MODULE__, {:store, key, data})
  end

  # Callback Functions
  @impl GenServer
  def init(_args) do
    File.mkdir_p!(@db_folder)
    {:ok, nil}
  end

  @impl GenServer
  def handle_call({:get, key}, _from, state) do
    data =
      case File.read(file_name(key)) do
        {:ok, contents} -> :erlang.binary_to_term(contents)
        _other -> nil
      end
    {:reply, data, state}
  end

  @impl GenServer
  def handle_cast({:store, key, data}, state) do
    key
    |> file_name()
    |> File.write!(:erlang.term_to_binary(data))

    {:noreply, state}
  end

  @impl GenServer
  def handle_info(_info, state) do
    {:noreply, state}
  end

  @impl GenServer
  def terminate(_reason, _state) do
    :ok
  end

  # Internal Functions
  defp file_name(key) do
    Path.join(@db_folder, to_string(key))
  end
end
