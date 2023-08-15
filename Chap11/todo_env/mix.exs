defmodule TodoEnv.MixProject do
  use Mix.Project

  def project do
    [
      app: :todo_env,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {TodoEnv.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poolboy, "~> 1.5"},
      {:cowboy, "~> 2.5"},
      {:plug_cowboy, "~> 2.0"}
    ]
  end
end
