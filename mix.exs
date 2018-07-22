defmodule BrickFTP.MixProject do
  use Mix.Project
  @version "0.1.1"

  def project do
    [
      app: :brickftp,
      version: @version,
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env),
      consolidate_protocols: not (Mix.env() in [:dev, :test]),
      deps: deps(),
      package: package(),
      source_url: "https://gitlab.com/rpip/brickftp",
      homepage_url: "https://gitlab.com/rpip/brickftp",
      description: "BrickFTP APi Client for Elixir",
      dialyzer: [ignore_warnings: "dialyzer.ignore-warnings"]
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
      {:httpoison, "~> 0.11"},
      {:poison, "~> 2.2 or ~> 3.0"},

      {:dialyxir, "~> 0.5", only: :dev, runtime: false},
      # Test
      # Docs
      {:ex_doc, "~> 0.18.0", only: :dev, runtime: false},
      {:earmark, "~> 1.2.0", only: :dev, runtime: false},
      {:inch_ex, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp package do
    [
      files: ~w(lib mix.exs README.md LICENSE CHANGELOG),
      maintainers: ["Yao Adzaku"],
      licenses: ["MIT"],
      links: %{github: "https://github.com/brickftp/brickftp-elixir"}
    ]
  end
end
