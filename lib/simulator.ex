defmodule GenMetricsBench.Simulator do

  @moduledoc """
  Behaviour plug-in for customized benchmark tests.

  The default simulator for GenServer cluster benchmarks is
  `GenMetricsBench.Simulator.ClusterDefault`.

  The default simulator for GenStage pipeline benchmarks is
  `GenMetricsBench.Simulator.PipelineDefault`.

  Create your own `Simulator` in order to customize the
  runtime characters of your own benchmarks. Then register
  that simulation in `config/config.exs`.
  """

  @doc """
  Return a message representative of the types of messages
  you want to test flowing through your cluster or pipeline.
  """
  @callback gen_msg() :: any

  @doc """
  Return a task delay (ms) representative of the approx time
  taken to process a message by a worker in your cluster or
  pipeline.
  """
  @callback gen_task_delay() :: non_neg_integer
end
