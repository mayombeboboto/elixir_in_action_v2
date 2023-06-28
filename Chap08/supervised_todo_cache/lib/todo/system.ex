defmodule Todo.System do
  use Supervisor

  @spec start_link() :: {:ok, pid()}
  def start_link() do
    Supervisor.start_link(__MODULE__, nil)
  end

  @impl Supervisor
  def init(_args) do
    Supervisor.init([{Todo.Cache, nil}], strategy: :one_for_one)
  end
end
