defmodule Demo do

  @spec print_abs(number()) :: no_return()
  def print_abs(value) do
    value
    |> abs()
    |> Integer.to_string()
    |> IO.puts()
  end
end
