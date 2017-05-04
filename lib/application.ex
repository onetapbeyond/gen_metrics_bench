defmodule GenMetricsBench.Application do
  use Application

  @moduledoc false

  def start(_type, _args) do
    {:ok, self()}
  end
end
