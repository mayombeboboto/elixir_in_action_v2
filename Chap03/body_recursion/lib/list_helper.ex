defmodule ListHelper do
  @moduledoc """
  Documentation for `ListHelper`.
  """

  def sum([]), do: 0
  def sum([head|tail]), do: head + sum(tail)
end
