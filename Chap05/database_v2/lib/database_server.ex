defmodule DatabaseServer do
  @moduledoc """
  Documentation for `DatabaseServer`.
  """

  @spec start() :: pid()
  def start do
    spawn(fn ->
      :rand.uniform(1000)
      |> loop()
    end)
  end

  @spec run_async(pid(), term()) :: no_return()
  def run_async(server_pid, query_def) do
    send(server_pid, {:run_query, self(), query_def})
  end

  @spec get_result() :: {:error, :timeout} | term()
  def get_result do
    receive do
      {:query_result, result} ->
        result
    after 5000 ->
      {:error, :timeout}
    end
  end

  defp loop(connection) do
    receive do
      {:run_query, from_pid, query_def} ->
        query_result = run_query(connection, query_def)
        send(from_pid, {:query_result, query_result})
    end
    loop(connection)
  end

  defp run_query(connection, query_def) do
    Process.sleep(2000)
    "Connecton #{connection}: #{query_def} result"
  end
end
