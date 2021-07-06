defmodule LivemanWeb.V1.UserController do
  use ElixirGoogleScraperWeb, :controller

  # alias LivemanWeb.V1.TokenView

  def show(_, params) do
    # render(conn, TokenView, "show.json", %{data: []})
    case ExOauth2Provider.Token.grant(params, otp_app: :my_app) do
      {:ok, access_token} ->
        IO.inspect(access_token, label: "access_token")

      # JSON response
      # JSON response
      {:error, error, http_status} ->
        IO.inspect(error, label: "Error")
        IO.inspect(http_status, label: "http_status")
    end
  end
end

# case ExOauth2Provider.Token.grant(params, otp_app: :my_app) do
#   {:ok, access_token}               -> # JSON response
#   {:error, error, http_status}      -> # JSON response
# end
