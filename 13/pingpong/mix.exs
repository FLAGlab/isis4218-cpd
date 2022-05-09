defmodule Pingpong.MixProject do
  use Mix.Project

  def project do
    [
      app: :pingpong,
      version: "0.1.0",
      elixir: "~> 1.9",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Pingpong.Application, []},
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [

    ]
  end
end
