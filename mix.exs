defmodule Scrivener.ESx.Mixfile do
  use Mix.Project

  @description """
  Pagination(Scrivener) for ESx
  """

  def project do
    [app: :scrivener_esx,
     version: "0.1.2",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: @description,
     package: package(),
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:scrivener, ">= 2.0.0"},
      {:esx, "~> 0.1"},

      {:earmark, ">= 0.0.0", only: :dev},
      {:ex_doc, "~> 0.10", only: :dev},
      {:inch_ex, only: :docs},
    ]
  end


  defp package do
    [ maintainers: ["Tatsuo Ikeda / ikeikeikeike"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/ikeikeikeike/scrivener_esx"},
    ]
  end

end
