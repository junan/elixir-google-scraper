defmodule ElixirGoogleScraper.Repo do
  use Ecto.Repo,
    otp_app: :elixir_google_scraper,
    adapter: Ecto.Adapters.Postgres
end
