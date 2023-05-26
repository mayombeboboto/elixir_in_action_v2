defmodule TodoServerTest do
  use ExUnit.Case
  doctest TodoServer

  test "entries" do
    todo_server = TodoServer.start()
    TodoServer.add_entry(todo_server, %{date: ~D[2018-12-19], title: "Dentist"})
    TodoServer.add_entry(todo_server, %{date: ~D[2018-12-20], title: "Shopping"})
    TodoServer.add_entry(todo_server, %{date: ~D[2018-12-19], title: "Movies"})

    assert([%{date: ~D[2018-12-20], id: 2, title: "Shopping"}],
           TodoServer.entries(todo_server, ~D[2018-12-20]))
  end
end
