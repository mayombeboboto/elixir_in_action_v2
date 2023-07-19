defmodule Todo.ProcessRegistry do
  @type regis() :: Registry
  @type key() :: term()

  @spec start_link() :: {:ok, pid()}
  def start_link() do
    Registry.start_link(keys: :unique, name: __MODULE__)
  end

  @spec via_tuple(key()) :: {:via, regis(), tuple()}
  def via_tuple(key) do
    {:via, Registry, {__MODULE__, key}}
  end

  @spec child_spec(term()) :: map()
  def child_spec(_args) do
    Supervisor.child_spec(
      Registry,
      id: __MODULE__,
      start: {__MODULE__, :start_link, []}
    )
  end
end
