defmodule ElixirGoogleScraperWeb.ApiCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias ExOauth2Provider.AccessTokens
      alias ExOauth2Provider.Applications

      def authenticated_request(user, conn, target, type, params \\ %{}) do
        attrs = %{name: "Application", redirect_uri: "https://example.org/endpoint"}
        file = %Plug.Upload{content_type: "text/csv", path: "test/fixture/keywords.csv"}

        {_, oauth_app} =
          Applications.create_application(nil, attrs, otp_app: :elixir_google_scraper)

        {_, acess_token} =
          AccessTokens.create_token(
            user,
            %{application: oauth_app},
            otp_app: :elixir_google_scraper
          )

        conn = put_req_header(conn, "authorization", "Bearer " <> acess_token.token)

        if type == :post do
          post(conn, target, params)
        else
          get(conn, target, params)
        end
      end
    end
  end
end
