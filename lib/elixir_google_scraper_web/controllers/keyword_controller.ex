defmodule ElixirGoogleScraperWeb.KeywordController do
  use ElixirGoogleScraperWeb, :controller

  alias ElixirGoogleScraper.Scraper

  def index(conn, _params) do
    render(conn, "index.html")
  end

  # def create(conn, _params) do
  # end

  def create(conn, %{"file" => %Plug.Upload{} = file}) do
    {alert_type, alert_message} =
      case Scraper.save_keywords(file, conn.assigns.current_user) do
        {:ok, :file_is_proccessed} ->
          {:info, "Your CSV file has been uploaded successfully"}

        {:ok, :file_size_exceed} ->
          {:info, "File size can't be more than 5 MB."}

        {:ok, :keyword_list_exceed} ->
          {:info, "CSV Keywords count can't be more than 1000"}

        {:error, :file_is_empty} ->
          {:error, "File can't be blank"}

        {:error, :file_is_invalid} ->
          {:error, "The keyword file is invalid!"}
      end

    conn
    |> put_flash(alert_type, alert_message)
    |> redirect(to: Routes.keyword_path(conn, :index))
  end
end
