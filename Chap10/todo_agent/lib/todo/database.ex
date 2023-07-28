defmodule Todo.Database do
  @db_folder "./persist"
  @pool_size 3

  @type key() :: term()
  @type value() :: term()

  # APIs
  @spec start_link() :: {:ok, pid()}
  def start_link() do
    File.mkdir_p!(@db_folder)

    children = Enum.map(1..@pool_size, &worker_spec/1)
    Supervisor.start_link(children, strategy: :one_for_one)
  end

  @spec child_spec(term()) :: map()
  def child_spec(_args) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :supervisor
    }
  end

  @spec store(key(), value()) :: no_return()
  def store(key, data) do
    key
    |> choose_worker()
    |> Todo.DatabaseWorker.store(key, data)
  end

  @spec get(key()) :: value()
  def get(key) do
    key
    |> choose_worker()
    |> Todo.DatabaseWorker.get(key)
  end

  # Choosing a worker makes a request to the database server process. There we
  # keep the knowledge about our workers, and return the pid of the corresponding
  # worker. Once this is done, the caller process will talk to the worker directly.
  defp choose_worker(key) do
    :erlang.phash2(key, @pool_size) + 1
  end

  defp worker_spec(worker_id) do
    default_worker_spec = {Todo.DatabaseWorker, {@db_folder, worker_id}}
    Supervisor.child_spec(default_worker_spec, id: worker_id)
  end
end
