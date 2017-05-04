defmodule GenMetricsBench.Pipeline do

  alias GenMetrics.GenStage.Pipeline
  alias GenMetricsBench.GenStage.Producer
  alias GenMetricsBench.GenStage.ProducerConsumer
  alias GenMetricsBench.GenStage.Consumer
  alias GenMetricsBench.Utils.Runtime

  @moduledoc """
  GenMetricsBench harness for GenStage Pipelines.

  This module provides a simple benchmark harness to
  load a simple GenStage pipeline with flexible message sizes
  and load volume.

  Using 'no_metrics/0` a benchmark can be run with GenMetrics
  data collection and reporting entirely disabled. This provides
  a baseline benchmark reading against which you can compare
  benchmarks run with GenMetrics activated.

  The following benchmarks can be run with various flavours
  of GenMetrics activated:

  - `summary_metrics/0'
  - `statistical_metrics/0`
  - `statsd_metrics/0`
  - `datadog_metrics/0`

  """

  @default_benchmark_load 10_000_000

  @doc """
  Run benchmark with all metrics gathering disabled.
  """
  def no_metrics do
    {simulator, sim_msg, sim_load} = build_benchmark()
    do_run({simulator, sim_msg, sim_load})
  end

  @doc """
  Run benchmark with in-memory summary metrics gathering enabled.
  """
  def summary_metrics do
    {simulator, sim_msg, sim_load} = build_benchmark()
    pipeline = %Pipeline{name: "bench_summary_metrics",
                         producer: [Producer],
                         producer_consumer: [ProducerConsumer],
                         consumer: [Consumer]}
    {:ok, _mid} = GenMetrics.monitor_pipeline(pipeline)
    do_run({simulator, sim_msg, sim_load})
  end

  @doc """
  Run benchmark with in-memory statistical metrics gathering enabled.
  """
  def statistical_metrics do
    {simulator, sim_msg, sim_load} = build_benchmark()
    pipeline = %Pipeline{name: "bench_summary_metrics",
                         producer: [Producer],
                         producer_consumer: [ProducerConsumer],
                         consumer: [Consumer], opts: [statistics: true]}
    {:ok, _mid} = GenMetrics.monitor_pipeline(pipeline)
    do_run({simulator, sim_msg, sim_load})
  end

  @doc """
  Run benchmark with `statsd` statistical metrics gathering enabled.
  """
  def statsd_metrics do
    {simulator, sim_msg, sim_load} = build_benchmark()
    pipeline = %Pipeline{name: "bench_summary_metrics",
                         producer: [Producer],
                         producer_consumer: [ProducerConsumer],
                         consumer: [Consumer], opts: [statistics: :statsd]}
    {:ok, _mid} = GenMetrics.monitor_pipeline(pipeline)
    do_run({simulator, sim_msg, sim_load})
  end

  @doc """
  Run benchmark with `datadog` statistical metrics gathering enabled.
  """
  def datadog_metrics do
    {simulator, sim_msg, sim_load} = build_benchmark()
    pipeline = %Pipeline{name: "bench_summary_metrics",
                         producer: [Producer],
                         producer_consumer: [ProducerConsumer],
                         consumer: [Consumer], opts: [statistics: :datadog]}
    {:ok, _mid} = GenMetrics.monitor_pipeline(pipeline)
    do_run({simulator, sim_msg, sim_load})
  end

  defp build_benchmark do
    simulator = Runtime.pipeline_simulator
    sim_msg = simulator.gen_msg
    sim_load = Application.get_env(:gen_metrics_bench,
      :benchmark_load, @default_benchmark_load)
    {simulator, sim_msg, sim_load}
  end

  defp do_run({_simulator, _sim_msg, sim_load}) do

    {:ok, producer} = GenStage.start_link(Producer, [])
    {:ok, prodcon} = GenStage.start_link(ProducerConsumer, [])
    {:ok, consumer} = GenStage.start_link(Consumer, sim_load)

    GenStage.sync_subscribe(consumer, to: prodcon)
    GenStage.sync_subscribe(prodcon, to: producer)

    Process.sleep(:infinity)
  end

end
