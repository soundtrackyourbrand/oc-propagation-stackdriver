defmodule OCPropagationStackdriver.MixProject do
  use Mix.Project

  def project do
    [
      app: :oc_propagation_stackdriver,
      description: "OpenCensus header propagation for Stackdriver/GCP",
      version: "0.2.0",
      elixir: "~> 1.9",
      deps: deps(),
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    %{
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/soundtrackyourbrand/oc-propagation-stackdriver"
      }
    }
  end

  defp deps do
    [{:ex_doc, "~> 0.21", only: :dev}]
  end
end
