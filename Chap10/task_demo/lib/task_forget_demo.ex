defmodule TaskForgetDemo do
  use Task

  def start_link(), do: Task.start_link(&loop/0)

  def loop() do
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
