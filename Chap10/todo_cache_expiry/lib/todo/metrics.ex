defmodule Todo.Metrics do
  use Task

  @spec start_link(term()) :: no_return()
  def start_link(_args), do: Task.start_link(&loop/0)

  defp loop() do
    Process.sleep(:timer.seconds(10))
    IO.inspect(collect_metrics())
    loop()
  end

  defp collect_metrics() do
    [
      memory_usage: :erlang.memory(:total),
      process_count: :erlang.system_info(:process_count)
    ]
  end
end
