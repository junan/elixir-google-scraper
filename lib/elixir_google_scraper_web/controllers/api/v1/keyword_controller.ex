defmodule ElixirGoogleScraperWeb.Api.V1.KeywordController do
  use ElixirGoogleScraperWeb, :controller

  alias ElixirGoogleScraper.Scraper.Keywords
  alias ElixirGoogleScraperWeb.V1.{ErrorView, KeywordView}
  alias ElixirGoogleScraperWeb.V1.KeywordSearchResultView
  alias ElixirGoogleScraperWeb.V1.KeywordView

  def index(conn, params) do
    {keywords, pagination} = Keywords.paginated_user_keywords(conn.assigns.current_user, params)

    render(conn, KeywordView, "index.json", %{data: keywords, meta: meta_data(pagination)})
  end

  def create(conn, %{"file" => %Plug.Upload{} = file}) do
    case Keywords.save_keywords(file, conn.assigns.current_user) do
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

  def show(conn, %{"id" => id}) do
    keyword = Keywords.get_keyword(id)

    if keyword do
      render(conn, KeywordSearchResultView, "show.json", %{data: keyword.search_result})
    else
      conn
      |> put_status(:not_found)
      |> render(ErrorView, "error.json", errors: [%{detail: "Keyword not found"}])
    end
  end

  defp meta_data(pagination) do
    %{
      page: pagination.page,
      pages: pagination.total_pages,
      page_size: pagination.per_page,
      records: pagination.total_count
    }
  end
end
