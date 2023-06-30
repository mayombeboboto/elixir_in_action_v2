defmodule Todo.System do
  use Supervisor

  @spec start_link(term()) :: {:ok, pid()}
  def start_link(_args) do
    Supervisor.start_link(__MODULE__, nil)
  end

  @impl Supervisor
  def init(_args) do
    Supervisor.init(
      [
        {Todo.Database, nil},
        {Todo.Cache, nil}
      ],
      strategy: :one_for_one
      )
  end
end
