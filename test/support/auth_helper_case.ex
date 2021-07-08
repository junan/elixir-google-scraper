defmodule ElixirGoogleScraperWeb.AuthHelperCase do
  use ExUnit.CaseTemplate

  import Plug.Conn

  alias ExOauth2Provider.AccessTokens
  alias ExOauth2Provider.Applications

  def authenticated_conn(conn, user) do
    attrs = %{name: "Application", redirect_uri: "https://example.org/endpoint"}

    {_, oauth_app} = Applications.create_application(nil, attrs, otp_app: :elixir_google_scraper)

    {_, access_token} =
      AccessTokens.create_token(
        user,
        %{application: oauth_app},
        otp_app: :elixir_google_scraper
      )

    put_req_header(conn, "authorization", "Bearer " <> access_token.token)
  end
end
