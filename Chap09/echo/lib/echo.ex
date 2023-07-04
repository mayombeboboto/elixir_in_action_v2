defmodule Echo do
  @moduledoc """
  Documentation for `Echo`.
  """

  use GenServer
  @registry :my_registry

  # APIs
  @spec start_link(term()) :: {:ok, pid()}
  def start_link(id) do
    GenServer.start_link(__MODULE__, nil, name: via_tuple(id))
  end

  @spec call(term(), term()) :: term()
  def call(id, some_request) do
    GenServer.call(via_tuple(id), some_request)
  end

  # Callback Functions
  @impl GenServer
  def init(nil), do: {:ok, %{}}

  @impl GenServer
  def handle_call(request, _from, state), do: {:reply, request, state}

  # Internal Functions
  defp via_tuple(id) do
    {:via, Registry, {@registry, {__MODULE__, id}}}
  end
end
