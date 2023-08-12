defmodule Todo.System do
  use Supervisor

  @spec start_link() :: {:ok, pid()}
  def start_link() do
    Supervisor.start_link(__MODULE__, nil)
  end

  @impl Supervisor
  def init(nil) do
    Supervisor.init(
      [
        Todo.Metrics,
        Todo.ProcessRegistry,
        Todo.Database,
        Todo.Cache
      ],
      strategy: :one_for_one
      )
  end
end
