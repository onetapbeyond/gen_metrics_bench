defmodule GenMetricsBench.GenServer.Server do
  use GenServer
  alias GenMetricsBench.Utils.Runtime

  @moduledoc false

  # The GenMetricsBench GenServer.
  # This GenServer simulates load on behalf of the benchmark
  # framework so GenMetrics can be measured for different
  # load volumes and message types.

  @handle_call_context "handle_call"
  @handle_cast_context "handle_cast"
  @handle_info_context "handle_info"

  def start_link(sim_load) do
    simulator = Runtime.cluster_simulator
    sim_task_delay = simulator.gen_task_delay
    GenServer.start_link(__MODULE__, {sim_load, sim_task_delay})
  end

  def init({sim_load, sim_task_delay}) do
    IO.puts "GenServer Cluster: benchmark starting, sim_load=#{sim_load}"
    {:ok, {sim_load, sim_task_delay, 0, 0}}
  end

  def handle_call(_msg, _from, state) do
    state = handle_callback(@handle_call_context, state)
    {:reply, :ok, state}
  end

  def handle_cast(_msg, state) do
    state = handle_callback(@handle_cast_context, state)
    {:noreply, state}
  end

  def handle_info(_msg, state) do
    state = handle_callback(@handle_info_context, state)
    {:noreply, state}
  end

  defp handle_callback(context,
    {sim_load, sim_task_delay, sim_task_start, sim_task_count}) do
    sim_task_start =
      case sim_task_start do
        0 -> System.monotonic_time(:millisecond)
        _ -> sim_task_start
      end
    Process.sleep(sim_task_delay)
    if sim_task_count + 1 >= sim_load  do
      time_taken = System.monotonic_time(:millisecond) - sim_task_start
      IO.puts "GenServer Cluster: #{context}, sim_load=#{sim_load} completed in #{inspect time_taken} ms"
    end
    {sim_load, sim_task_delay, sim_task_start, sim_task_count + 1}
  end

end
