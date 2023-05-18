defmodule Employee do
  @moduledoc """
  Documentation for `Employee`.
  """
  @employees ~w(Alice Bob John)s

  def employee_v1 do
    @employees
    |> Enum.with_index()
    |> Enum.each(
      fn {employee, index} ->
        IO.puts("#{index+1}. #{employee}")
      end
    )
  end

  def employee_v2 do
    @employees
    |> Stream.with_index()
    |> Enum.each(
      fn {employee, index} ->
        IO.puts("#{index+1}. #{employee}")
      end
    )
  end
end
