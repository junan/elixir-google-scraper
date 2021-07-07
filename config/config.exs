# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :elixir_google_scraper,
  ecto_repos: [ElixirGoogleScraper.Repo]

# Configures the endpoint
config :elixir_google_scraper, ElixirGoogleScraperWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "lOtmwAN+U9nB8srM1KMY37dHgA28ug4ofnW66fEwAyzFfeYwqHQjvosIz7u1u8Sx",
  render_errors: [view: ElixirGoogleScraperWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ElixirGoogleScraper.PubSub,
  live_view: [signing_salt: "LCl1+ieh"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :elixir_google_scraper, Oban,
  repo: ElixirGoogleScraper.Repo,
  plugins: [Oban.Plugins.Pruner],
  queues: [default: 10]

config :elixir_google_scraper, ExOauth2Provider,
  repo: ElixirGoogleScraper.Repo,
  resource_owner: ElixirGoogleScraper.Account.Schemas.User,
  password_auth: {ElixirGoogleScraper.Account.Users, :authenticate}

config :jsonapi,
  field_transformation: :underscore,
  remove_links: true,
  json_library: Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
