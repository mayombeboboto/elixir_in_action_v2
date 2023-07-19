defmodule TaskAwaitDemo do
  def demo() do
    1..5
    |> Enum.map(&Task.async(fn -> lambda("query #{&1}") end))
    |> Enum.map(&Task.await/1)
  end

  defp lambda(query) do
    Process.sleep(2000)
    "#{query} result"
  end
end
