defmodule Arithmetic do
  @moduledoc """
  Documentation for `Arithmetic`.
  """

  def multiplication_table do
    for x <- 1..9, y <- 1..9, x <= y, into: %{} do
      {{x, y}, x*y}
    end
  end
end
