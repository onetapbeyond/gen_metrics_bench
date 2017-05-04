defmodule GenMetricsBench.Mixfile do
  use Mix.Project

  def project do
    [app: :gen_metrics_bench,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description(),
     package: package(),
     deps: deps(),
     docs: [main: "GenMetricsBench", source_url: "https://github.com/onetapbeyond/gen_metrics_bench"]
     ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger],
     mod: {GenMetricsBench.Application, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:gen_metrics, "~> 0.2.0"},
     {:ex_doc, "~> 0.14", only: :dev, runtime: false},
     {:credo, "~> 0.7", only: [:dev, :test]}]
  end

  defp description do
    """
    An Elixir GenMetrics benchmarking tool for GenServer and GenStage applications. 
    """
  end

  defp package do
    [
      name: :gen_metrics_bench,
      maintainers: ["David Russell"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/onetapbeyond/gen_metrics_bench"}
    ]
  end
end
