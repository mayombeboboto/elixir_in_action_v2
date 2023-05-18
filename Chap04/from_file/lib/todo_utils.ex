defmodule TodoUtils do
  alias :erlang, as: Erlang
  @path "./todo.csv"

  def get_entries() do
    File.stream!(@path)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Stream.map(&String.split(&1, ","))
    |> Enum.map(&to_map!/1)
  end

  defp to_map!([date, title]) do
    %{ date: format_date!(date), title: title }
  end

  defp format_date!(date) do
    String.split(date, "/")
    |> Enum.map(&String.to_integer/1)
    |> Erlang.list_to_tuple()
    |> Date.from_erl!()
  end
end
