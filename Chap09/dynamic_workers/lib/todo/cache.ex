defmodule Todo.Cache do
  @registry Todo.ProcessRegistry

  # APIs
  @spec start_link() :: {:ok, pid()}
  def start_link() do
    IO.puts("Starting to-do cache.")

    DynamicSupervisor.start_link(
      name: __MODULE__,
      strategy: :one_for_one
    )
  end

  # Version 1 will always try to start Todo.Server first
  # Only when it fails with `already started` error that
  # It stops.
  @spec server_process_v1(binary()) :: pid()
  def server_process_v1(todo_list_name) do
    case start_child(todo_list_name) do
      {:error, {:already_started, server}} -> server
      {:ok, server} -> server
    end
  end

  # Version 2 checks the value the registry first
  # Then only start Todo.Server.
  @spec server_process_v2(binary()) :: pid()
  def server_process_v2(todo_list_name) do
    case Registry.lookup(@registry, {Todo.Server, todo_list_name}) do
      [] ->
        {:ok, server} = start_child(todo_list_name)
        server
      [{server, _data}|_rest] ->
        server
    end
  end

  def child_spec(_args) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      shutdown: 2000,
      restart: :permanent
    }
  end

  # Internal Function
  defp start_child(todo_list_name) do
    DynamicSupervisor.start_child(
      __MODULE__,
      {Todo.Server, todo_list_name}
    )
  end
end
