defmodule Pluggy.MixProject do
  use Mix.Project

  def project do
    [
      app: :pluggy,
      version: "0.4.0",
      elixir: "~> 1.14.0",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:cowboy, :plug, :postgrex],
      extra_applications: [:logger, :bcrypt_elixir, :elixir_uuid],
      mod: {Pluggy, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  def deps do
    [
      {:plug_cowboy, "~> 2.5.2"},
      {:postgrex, "~> 0.16.4"},
      {:bcrypt_elixir, "~> 3.0.1"},
      {:slime, "~> 1.3.0"},
      {:elixir_uuid, "~> 1.2"}
    ]
  end
end
