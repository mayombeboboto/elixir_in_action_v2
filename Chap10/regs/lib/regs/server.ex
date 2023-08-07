defmodule Regs.Server do
  use GenServer
  alias :ets, as: ETS

  @spec start_link() :: {:ok, pid()}
  def start_link(), do: GenServer.start_link(__MODULE__, nil, name: __MODULE__)

  @spec register(term()) :: {:ok, :success} | {:error, :duplicate}
  def register(key), do: GenServer.call(__MODULE__, {:register, self(), key})

  @spec whereis(term()) :: nil | pid()
  def whereis(key), do: GenServer.call(__MODULE__, {:whereis, key})

  @impl true
  def init(nil) do
    Process.flag(:trap_exit, true)
    ETS.new(__MODULE__, [:named_table])
    {:ok, nil}
  end

  @impl true
  def handle_call({:register, pid, key}, _from, state) do
    case ETS.lookup(__MODULE__, key) do
      [] ->
        Process.link(pid)
        ETS.insert(__MODULE__, {key, pid})
        {:reply, {:ok, :success}, state}
      [{^key, _value}] ->
        {:reply, {:error, :duplicate}, state}
    end
  end

  def handle_call({:whereis, key}, _from, state) do
    case ETS.lookup(__MODULE__, key) do
      [{^key, pid}] -> {:reply, pid, state}
      [] -> {:reply, nil, state}
    end
  end

  @impl true
  def handle_info({:EXIT, pid, _reason}, state) do
    ETS.match_delete(__MODULE__, {:_, pid})
    {:noreply, state}
  end
end
