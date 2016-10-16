defmodule BankPlatform.Mixfile do
  use Mix.Project

  def project do
    [apps_path: "apps",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     aliases: aliases()]
  end

  defp deps do
    [
			{:floki, "~> 0.11.0"},
		]
  end

  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "ecto.seed"],
     "ecto.seed": ["run apps/bank/priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
