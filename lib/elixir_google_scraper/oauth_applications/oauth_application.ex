defmodule ElixirGoogleScraper.OauthApplications.OauthApplication do
  use Ecto.Schema
  use ExOauth2Provider.Applications.Application, otp_app: :elixir_google_scraper

  schema "oauth_applications" do
    application_fields()

    timestamps()
  end
end
