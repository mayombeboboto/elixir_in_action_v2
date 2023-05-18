defmodule ListHelper do
  @moduledoc """
  Documentation for `ListHelper`.
  """

  def sum(list), do: sum(0, list)

  defp sum(acc, []), do: acc
  defp sum(acc, [head|tail]), do: sum(head+acc, tail)
end
