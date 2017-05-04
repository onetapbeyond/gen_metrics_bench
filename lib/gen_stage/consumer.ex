defmodule GenMetricsBench.GenStage.Consumer do
  use GenStage

  @moduledoc false

  # The GenMetricsBench GenStage Consumer.
  # This GenStage consumer simulates load on behalf of
  # the benchmark framework so GenMetrics can be measured for
  # different load volumes and message types.

  def start_link(sim_load) do
    GenStage.start_link(__MODULE__, sim_load)
  end

  def init(sim_load) do
    IO.puts "GenStage Pipeline: benchmark starting, sim_load=#{sim_load}"
    {:consumer, {sim_load, 0, 0}}
  end

  def handle_events(events, _from, {sim_load, sim_task_start, sim_task_count}) do
    num_of_events = length(events)
    sim_task_start =
      case sim_task_start do
        0 -> System.monotonic_time(:millisecond)
        _ -> sim_task_start
      end
    if sim_task_count + num_of_events >= sim_load  do
      time_taken = System.monotonic_time(:millisecond) - sim_task_start
      IO.puts "GenStage Pipeline: sim_load=#{sim_load} completed in #{inspect time_taken} ms"
      Process.exit(self(), :benchmark_completed)
    end
    {:noreply, [], {sim_load, sim_task_start, sim_task_count + num_of_events}}
  end

end
