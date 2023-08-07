defmodule Test.Utils do
  use GenServer

  def start_link(), do: GenServer.start_link(__MODULE__, nil)

  def stop(server), do: GenServer.stop(server)

  def register(server, key), do: GenServer.call(server, {:register, key})

  def init(nil), do: {:ok, nil}

  def handle_call({:register, key}, _from, state) do
    {:reply, Regs.Server.register(key), state}
  end

  def terminate(_reason, _state), do: :ok
end
