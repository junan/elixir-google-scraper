defmodule ElixirGoogleScraper.OauthAccessTokens.OauthAccessToken do
  use Ecto.Schema
  use ExOauth2Provider.AccessTokens.AccessToken, otp_app: :elixir_google_scraper

  schema "oauth_access_tokens" do
    access_token_fields()

    timestamps()
  end
end
