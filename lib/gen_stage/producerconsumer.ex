defmodule GenMetricsBench.GenStage.ProducerConsumer do
  use GenStage
  alias GenMetricsBench.Utils.Runtime

  @moduledoc false

  # The GenMetricsBench GenStage Producer-Consumer.
  # This GenStage producer-consumer simulates load on behalf of
  # the benchmark framework so GenMetrics can be measured for
  # different load volumes and message types.

  def start_link do
    GenStage.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    simulator = Runtime.pipeline_simulator
    sim_task_delay = simulator.gen_task_delay
    {:producer_consumer, sim_task_delay}
  end

  def handle_events(events, _from, sim_task_delay) do
    # Simulate workload based on sim_task_delay for current simulator.
    Process.sleep(sim_task_delay)
    {:noreply, events, sim_task_delay}
  end

end
