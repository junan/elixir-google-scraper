defmodule ElixirGoogleScraperWeb.Api.V1.TokenController do
  use ElixirGoogleScraperWeb, :controller

  alias ElixirGoogleScraperWeb.V1.ErrorView
  alias ElixirGoogleScraperWeb.V1.TokenView

  def create(conn, params) do
    case ExOauth2Provider.Token.grant(params, otp_app: :elixir_google_scraper) do
      {:ok, access_token} ->
        render(conn, TokenView, "show.json", %{
          data: Map.put(access_token, :id, :rand.uniform(100))
        })

      {:error, _, _} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ErrorView, "error.json", errors: [%{detail: "Authentiocation failed"}])
    end
  end
end
