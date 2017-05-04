defmodule GenMetricsBench.Simulator.ClusterDefault do
  @behaviour GenMetricsBench.Simulator

  @moduledoc """
  Default plug-in behaviour for GenServer cluster benchmark tests.

  Clone or customize this module to create benchmarks with runtime
  characteristics that mirror your dev or production environments.

  If clone, remember to register your new simulator module in the
  `config/config.exs` configuraton file.
  """

  def gen_msg do
    :ok
  end

  def gen_task_delay do
    # delay represents GenServer handle_* callback
    # simulated workload processing time (ms)
    1
  end
end
