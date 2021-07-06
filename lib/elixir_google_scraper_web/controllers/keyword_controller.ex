defmodule ElixirGoogleScraperWeb.KeywordController do
  use ElixirGoogleScraperWeb, :controller

  alias ElixirGoogleScraper.Repo
  alias ElixirGoogleScraper.Scraper.Keywords
  alias ElixirGoogleScraper.Scraper.Schemas.Keyword

  def index(conn, params) do
    {keywords, pagination} = Keywords.paginated_user_keywords(conn.assigns[:current_user], params)

    render(conn, "index.html", keywords: keywords, pagination: pagination)
  end

  def create(conn, %{"file" => %Plug.Upload{} = file}) do
    {flash_type, flash_message} =
      case Keywords.save_keywords(file, conn.assigns.current_user) do
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

  def show(conn, %{"id" => id}) do
    keyword = Repo.get_by(Keyword, %{id: id})

    render(conn, "show.html", keyword: Repo.preload(keyword, :search_result))
  end

  def html(conn, %{"keyword_id" => id}) do
    keyword = Repo.get_by(Keyword, %{id: id})

    render(conn, "html_response.html", keyword: Repo.preload(keyword, :search_result))
  end
end
