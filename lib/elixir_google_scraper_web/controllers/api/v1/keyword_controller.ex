defmodule ElixirGoogleScraperWeb.Api.V1.KeywordController do
  use ElixirGoogleScraperWeb, :controller

  alias ElixirGoogleScraper.Scraper.Keywords
  alias ElixirGoogleScraperWeb.V1.ErrorView

  plug(ExOauth2Provider.Plug.VerifyHeader, otp_app: :elixir_google_scraper, realm: "Bearer")

  plug(ExOauth2Provider.Plug.EnsureAuthenticated,
    handler: ElixirGoogleScraperWeb.Api.ErrorHandler
  )

  def create(conn, %{"file" => %Plug.Upload{} = file}) do
    token = ExOauth2Provider.Plug.current_access_token(conn)

    case Keywords.save_keywords(file, token.resource_owner) do
      :ok ->
        conn
        |> put_resp_header("content-type", "application/json")
        |> send_resp(201, "")

      {:error, :file_is_empty} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ErrorView, "error.json", errors: [%{detail: "File can't be empty"}])

      {:error, :keyword_list_exceeded} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ErrorView, "error.json",
          errors: [%{detail: "CSV Keywords count can't be more than 1000"}]
        )
    end
  end
end
