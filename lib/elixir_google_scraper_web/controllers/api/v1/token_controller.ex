defmodule ElixirGoogleScraperWeb.Api.V1.TokenController do
  use ElixirGoogleScraperWeb, :controller

  # alias LivemanWeb.V1.TokenView

  def show(conn, params) do
    # render(conn, TokenView, "show.json", %{data: []})
    case ExOauth2Provider.Token.grant(params, otp_app: :elixir_google_scraper) do
      {:ok, access_token} ->
        IO.inspect(access_token, label: "access_token")
        send_resp(conn, :created, "")

      # JSON response
      # JSON response
      {:error, error, http_status} ->
        IO.inspect(error, label: "Error")
        IO.inspect(http_status, label: "Status")
        send_resp(conn, :created, "Error")
    end
  end
end

# case ExOauth2Provider.Token.grant(params, otp_app: :my_app) do
#   {:ok, access_token}               -> # JSON response
#   {:error, error, http_status}      -> # JSON response
# end
