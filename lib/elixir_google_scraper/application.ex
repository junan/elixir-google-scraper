defmodule ElixirGoogleScraper.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      ElixirGoogleScraper.Repo,
      # Start the Telemetry supervisor
      ElixirGoogleScraperWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ElixirGoogleScraper.PubSub},
      # Start the Endpoint (http/https)
      ElixirGoogleScraperWeb.Endpoint,
      {Oban, oban_config()}
      # Start a worker by calling: ElixirGoogleScraper.Worker.start_link(arg)
      # {ElixirGoogleScraper.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirGoogleScraper.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ElixirGoogleScraperWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  # Conditionally disable crontab, queues, or plugins here.
  defp oban_config do
    Application.get_env(:elixir_google_scraper, Oban)
  end
end
