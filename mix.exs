defmodule IpMonitor.MixProject do
  use Mix.Project

  @version "0.1.0"
  @scm_url "https://github.com/odelbos/le-elixir-5-ipmonitor"

  def project do
    [
      app: :ip_monitor,
      version: @version,
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      name: "Ip Monitor",
      source_url: @scm_url,
      description: "Monitoring IP change, using external service."
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {IpMonitor.Application, []}
    ]
  end

  defp deps do
    [
    ]
  end

  # -----

  defp package do
    [
      maintainers: ["Olivier Delbos"],
      licenses: ["MIT"],
      links: %{"GitHub" => @scm_url}
    ]
  end
end
