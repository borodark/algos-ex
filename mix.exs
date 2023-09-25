defmodule Algos.MixProject do
  use Mix.Project

  def project do
    [
      app: :algos,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:axon, "~> 0.5"},
      {:nx, "~> 0.5"},
      {:explorer, "~> 0.5"},
      {:kino, "~> 0.8"},
      {:exla, "~> 0.5"},
      {:benchee, "~> 1.0"},
      {:torchx, "~> 0.5"}
    ]
  end
end
