defmodule GenMetricsBench.Cluster do

  alias GenMetrics.GenServer.Cluster
  alias GenMetricsBench.GenServer.Server
  alias GenMetricsBench.Utils.Runtime

  @moduledoc """
  GenMetricsBench harness for GenServer Clusters.

  This module provides a simple benchmark harness to
  load a simple GenServer with flexible message sizes
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

  # GenServer operations: :call, :cast, :info
  @benchmark_operation :info
  @default_benchmark_load 10_000

  @doc """
  Run benchmark with all metrics gathering disabled.
  """

  def no_metrics do
    {simulator, sim_msg, sim_load} = build_benchmark()
    {:ok, pid} = Server.start_link(sim_load)
    do_run(pid, {simulator, sim_msg, sim_load})
  end

  @doc """
  Run benchmark with in-memory summary metrics gathering enabled.
  """
  def summary_metrics do
    {simulator, sim_msg, sim_load} = build_benchmark()
    {:ok, pid} = Server.start_link(sim_load)
    cluster = %Cluster{name: "bench_summary_metrics", servers: [Server]}
    {:ok, _mid} = GenMetrics.monitor_cluster(cluster)
    do_run(pid, {simulator, sim_msg, sim_load})
  end

  @doc """
  Run benchmark with in-memory statistical metrics gathering enabled.
  """
  def statistical_metrics do
    {simulator, sim_msg, sim_load} = build_benchmark()
    {:ok, pid} = Server.start_link(sim_load)
    cluster = %Cluster{name: "bench_statistical_metrics",
                       servers: [Server], opts: [statistics: true]}
    {:ok, _mid} = GenMetrics.monitor_cluster(cluster)
    do_run(pid, {simulator, sim_msg, sim_load})
  end

  @doc """
  Run benchmark with `statsd` statistical metrics gathering enabled.
  """
  def statsd_metrics do
    {simulator, sim_msg, sim_load} = build_benchmark()
    {:ok, pid} = Server.start_link(sim_load)
    cluster = %Cluster{name: "bench_statsd_metrics",
                       servers: [Server], opts: [statistics: :statsd]}
    {:ok, _mid} = GenMetrics.monitor_cluster(cluster)
    do_run(pid, {simulator, sim_msg, sim_load})
  end

  @doc """
  Run benchmark with `datadog` statistical metrics gathering enabled.
  """
  def datadog_metrics do
    {simulator, sim_msg, sim_load} = build_benchmark()
    {:ok, pid} = Server.start_link(sim_load)
    cluster = %Cluster{name: "bench_datadog_metrics",
                       servers: [Server], opts: [statistics: :datadog]}
    {:ok, _mid} = GenMetrics.monitor_cluster(cluster)
    do_run(pid, {simulator, sim_msg, sim_load})
  end

  defp build_benchmark do
    simulator = Runtime.cluster_simulator
    sim_msg = simulator.gen_msg
    sim_load = Application.get_env(:gen_metrics_bench,
      :benchmark_load, @default_benchmark_load)
    {simulator, sim_msg, sim_load}
  end

  defp do_run(pid, {_, sim_msg, sim_load}) do
    for _ <- 1..sim_load do
      case @benchmark_operation do
        :info -> Kernel.send(pid, sim_msg)
        _     -> apply(GenServer, @benchmark_operation, [pid, sim_msg])
      end
    end
    :ok
  end

end
