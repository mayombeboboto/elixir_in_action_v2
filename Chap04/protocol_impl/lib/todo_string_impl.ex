defmodule TodoStringImpl do
  defimpl String.Chars, for: TodoList do
    def to_string(todo_list) do
      auto_id = TodoList.auto_id(todo_list)
      entries =
        TodoList.all_entries(todo_list)
        |> Enum.into([])
        |> entries_to_string()

      "%TodoList{" <> "\n auto_id: " <>
      Integer.to_string(auto_id) <> "," <>
      "\n entries: %{\n" <> entries <> "\n }\n}"
    end

    def entries_to_string([]) do
      "  %{}"
    end

    def entries_to_string(entries = [_head|_tail]) do
      entries_to_string(entries, "")
    end

    def entries_to_string([{key, value}], acc) do
      acc <> "  %{" <> Integer.to_string(key) <> " => " <> inspect(value) <> "}"
    end

    def entries_to_string([{key, value}|rest], acc) do
      acc = acc <> "  %{" <> Integer.to_string(key) <> " => " <> inspect(value) <> "},\n"
      entries_to_string(rest, acc)
    end
  end
end
