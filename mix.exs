defmodule UuidCli.MixProject do
  use Mix.Project

  def project do
    [
      app: :uuid_cli,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: [main_module: UuidCli, name: "uuid"],
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :crypto]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:optimus, "~> 0.3.0"},
      {:uuid, "~> 1.1"}
    ]
  end

  defp aliases do
    [
      install: ["escript.install --force"]
    ]
  end
end
