defmodule Shortener.MixProject do
  use Mix.Project

  def project do
    [
      app: :shortener,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Shortener.Application, []}
    ]
  end

  defp deps do
    [
      {:plug_cowboy, "~> 2.0"},
      {:jason, "~> 1.2"},
      {:httpoison, "~> 1.8"},
    ]
  end
end
