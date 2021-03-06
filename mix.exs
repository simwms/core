defmodule Core.Mixfile do
  use Mix.Project

  def project do
    [app: :core,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [mod: {Core, []},
     applications: [:phoenix, :phoenix_html, :cowboy, :logger,
                    :phoenix_ecto, :postgrex, :comeonin, :fox,
                    :cors_plug, :stripex, :gateway]]
  end

  # Specifies which paths to compile per environment
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [{:phoenix, "~> 0.16"},
     {:phoenix_ecto, "~> 1.0"},
     {:mariaex, ">= 0.0.0", only: [:test, :dev]},
     {:postgrex, "~> 0.9.1"},
     {:phoenix_html, "~> 2.0"},
     {:phoenix_live_reload, "~> 0.6", only: :dev},
     {:cowboy, "~> 1.0"},
     {:comeonin, "~> 1.1"},
     {:fox, "~> 0.1"},
     {:cors_plug, "~> 0.1.3"},
     {:stripex, "~>0.1"},
     {:pipe, "~> 0.0.2"},
     {:gateway, "~>0.0.5"}]
  end
end