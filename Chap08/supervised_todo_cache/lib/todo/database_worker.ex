defmodule Todo.DatabaseWorker do
  use GenServer

  @type path() :: binary()
  @type key() :: term()
  @type value() :: term()

  @spec start_link(path()) :: {:ok, pid()}
  def start_link(db_folder) do
    IO.puts("Starting database worker.")
    GenServer.start(__MODULE__, db_folder)
  end

  @spec store(pid(), key(), value()) :: no_return()
  def store(worker_pid, key, data) do
    GenServer.cast(worker_pid, {:store, key, data})
  end

  @spec get(pid(), key()) :: value()
  def get(worker_pid, key) do
    GenServer.call(worker_pid, {:get, key})
  end

  @impl GenServer
  def init(db_folder) do
    {:ok, db_folder}
  end

  @impl GenServer
  def handle_cast({:store, key, data}, db_folder) do
    db_folder
    |> file_name(key)
    |> File.write!(:erlang.term_to_binary(data))

    {:noreply, db_folder}
  end

  @impl GenServer
  def handle_call({:get, key}, _, db_folder) do
    data =
      case File.read(file_name(db_folder, key)) do
        {:ok, contents} -> :erlang.binary_to_term(contents)
        _ -> nil
      end

    {:reply, data, db_folder}
  end

  defp file_name(db_folder, key) do
    Path.join(db_folder, to_string(key))
  end
end
