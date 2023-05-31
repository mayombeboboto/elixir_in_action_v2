defmodule KeyValueStore do
  @moduledoc """
  Documentation for `KeyValueStore`.
  """
  use GenServer
  alias :timer, as: Timer

  # APIs
  @spec start() :: {:ok, pid()}
  def start do
    GenServer.start(
      __MODULE__,
      nil,
      name: __MODULE__
    )
  end

  @spec get(term()) :: term()
  def get(key), do: GenServer.call(__MODULE__, {:get, key})

  @spec put(term(), term()) :: no_return()
  def put(key, value) do
    GenServer.cast(__MODULE__, {:put, key, value})
  end

  # Callback Functions
  @impl GenServer
  def init(_args) do
    Timer.send_interval(5000, :cleanup)
    {:ok, %{}}
  end

  @impl GenServer
  def handle_call({:get, key}, _from, state) do
    {:reply, Map.get(state, key), state}
  end

  @impl GenServer
  def handle_cast({:put, key, value}, state) do
    {:noreply, Map.put(state, key, value)}
  end

  @impl GenServer
  def handle_info(:cleanup, _state) do
    {:noreply, %{}}
  end

  @impl GenServer
  def terminate(reason, state) do
    IO.puts("Server terminated with reason: #{inspect(reason)}")
    IO.puts("Server state: #{inspect(state)}")
  end
end
