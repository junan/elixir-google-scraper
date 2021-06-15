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
        {:ok, :file_is_proccessed} -> {:info, "The keyword file is processed successfully!"}
        {:error, :file_is_empty} -> {:error, "The keyword file is empty!"}
        {:error, :file_is_invalid} -> {:error, "The keyword file is invalid!"}
      end

    IO.inspect(alert_type, label: "Alert type")
    IO.inspect(alert_message, label: "Alert message")

    conn
    |> put_flash(alert_type, alert_message)
    |> redirect(to: Routes.keyword_path(conn, :index))
  end
end
