defmodule ElixirGoogleScraperWeb.KeywordController do
  use ElixirGoogleScraperWeb, :controller

  alias ElixirGoogleScraper.Scraper

  def index(conn, _params) do
    keywords = Scraper.list_keywords(conn.assigns[:current_user])
    render(conn, "index.html", keywords: keywords)
  end

  def create(conn, %{"file" => %Plug.Upload{} = file}) do
    {flash_type, flash_message} =
      case Scraper.save_keywords(file, conn.assigns.current_user) do
        :ok ->
          {:info, "Your CSV file has been uploaded successfully"}

        {:error, :keyword_list_exceeded} ->
          {:info, "CSV Keywords count can't be more than 1000"}

        {:error, :file_is_empty} ->
          {:error, "File can't be blank"}
      end

    conn
    |> put_flash(flash_type, flash_message)
    |> redirect(to: Routes.keyword_path(conn, :index))
  end
end
