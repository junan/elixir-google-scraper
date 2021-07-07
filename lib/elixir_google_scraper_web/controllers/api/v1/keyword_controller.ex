defmodule ElixirGoogleScraperWeb.Api.V1.KeywordController do
  use ElixirGoogleScraperWeb, :controller

  alias ElixirGoogleScraper.Repo
  alias ElixirGoogleScraperWeb.V1.ErrorView
  alias ElixirGoogleScraper.Scraper.Keywords
  alias ElixirGoogleScraper.Account.Schemas.User

  import Ecto.Query

  def create(conn, %{"file" => %Plug.Upload{} = file}) do
    user = User |> first() |> Repo.one()

    case Keywords.save_keywords(file, user) do
      :ok ->
        conn
        |> put_resp_header("content-type", "application/json")
        |> send_resp(201, "")

      {:error, :file_is_empty} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ErrorView, "error.json", errors: [%{detail: "File cant be empty"}])

      {:error, :keyword_list_exceeded} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ErrorView, "error.json",
          errors: [%{detail: "CSV Keywords count can't be more than 1000"}]
        )
    end
  end
end
