defmodule GenMetricsBench.Utils.Runtime do

  @moduledoc false

  @default_cluster_simulator  GenMetricsBench.Simulator.ClusterDefault
  @default_pipeline_simulator GenMetricsBench.Simulator.PipelineDefault

  # Located, load and verify simulator module for cluster benchmarks.
  def cluster_simulator do
    simulator = Application.get_env(:gen_metrics_bench,
      :cluster_simulator, @default_cluster_simulator)
    Code.eval_string("require #{inspect simulator}")
    simulator
  end

  # Located, load and verify simulator module for pipeline benchmarks.
  def pipeline_simulator do
    simulator = Application.get_env(:gen_metrics_bench,
      :pipeline_simulator, @default_pipeline_simulator)
    Code.eval_string("require #{inspect simulator}")
    simulator
  end

end
