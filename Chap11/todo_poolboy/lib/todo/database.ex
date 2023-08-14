defmodule Todo.Database do
  @db_folder "./persist"
  alias :poolboy, as: PoolBoy

  def child_spec(_args) do
    File.mkdir_p!(@db_folder)

    PoolBoy.child_spec(
      __MODULE__,
      [
        name: {:local, __MODULE__},
        worker_module: Todo.DatabaseWorker,
        size: 3
      ],
      [@db_folder]
    )
  end

  def store(key, data) do
    PoolBoy.transaction(
      __MODULE__,
      fn worker_pid ->
        Todo.DatabaseWorker.store(worker_pid, key, data)
      end
    )
  end

  def get(key) do
    PoolBoy.transaction(
      __MODULE__,
      fn worker_pid ->
        Todo.DatabaseWorker.get(worker_pid, key)
      end
    )
  end
end
