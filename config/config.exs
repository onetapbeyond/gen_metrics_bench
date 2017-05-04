# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# Customize the :gen_metrics_bench configuration to run
# benchmark tests using your own custom simulators that
# implement the GenMetricsBench.Simulator behaviour.

config :gen_metrics_bench,
  # benchmark_load: 1_000_000,
  cluster_simulator: GenMetricsBench.Simulator.ClusterDefault,
  pipeline_simulator: GenMetricsBench.Simulator.PipelineDefault
