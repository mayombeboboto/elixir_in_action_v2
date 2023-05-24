defmodule Calculator do
  @moduledoc """
  Documentation for `Calculator`.
  """

  @spec start() :: pid()
  def start do
    spawn(fn -> loop(0) end)
  end

  @spec value(pid()) :: number() | {:error, :timeout}
  def value(server_pid) do
    send(server_pid, {:value, self()})
    receive do
      {:response, value} ->
        value
      after 5000 ->
        {:error, :timeout}
    end
  end

  @spec add(pid(), number()) :: no_return()
  def add(server_pid, value), do: send(server_pid, {:add, value})

  @spec sub(pid(), number()) :: no_return()
  def sub(server_pid, value), do: send(server_pid, {:sub, value})

  @spec mul(pid(), number()) :: no_return()
  def mul(server_pid, value), do: send(server_pid, {:mul, value})

  @spec div(pid(), number()) :: no_return()
  def div(server_pid, value), do: send(server_pid, {:div, value})

  defp loop(current_value) do
    new_value = receive do
        {:value, caller} ->
          send(caller, {:response, current_value})
          current_value
        {:add, value} when is_number(value) -> current_value + value
        {:sub, value} when is_number(value) -> current_value - value
        {:mul, value} when is_number(value) -> current_value * value
        {:div, value} when is_number(value) -> current_value / value
        unknown_request ->
          IO.puts("Invalid request #{inspect(unknown_request)}")
          current_value
      end
    loop(new_value)
  end
end
