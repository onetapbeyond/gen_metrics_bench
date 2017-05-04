defmodule GenMetricsBench.GenStage.Producer do
  use GenStage
  alias GenMetricsBench.Utils.Runtime

  @moduledoc false

  # The GenMetricsBench GenStage Producer.
  # This GenStage producer simulates load on behalf of the
  # benchmark framework so GenMetrics can be measured for
  # different load volumes and message types.

  def start_link do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(_) do
    simulator = Runtime.pipeline_simulator
    {:producer, simulator}
  end

  def handle_demand(demand, simulator) do
    events = for _ <- 1..demand, do: simulator.gen_msg
    {:noreply, events, simulator}
  end
end
