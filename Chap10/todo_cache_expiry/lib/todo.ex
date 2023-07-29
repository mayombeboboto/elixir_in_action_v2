defmodule Todo do
  @moduledoc """
  Documentation for `Todo`.
  """
  use Application

  @type type() :: :normal
  @type args() :: []

  @spec start(type(), args()) :: {:ok, pid()}
  def start(_type, _args) do
    Supervisor.start_link([Todo.System], strategy: :one_for_one)
  end
end
