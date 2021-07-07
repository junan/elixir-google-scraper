defmodule ElixirGoogleScraperWeb.Api.V1.KeywordController do
  use ElixirGoogleScraperWeb, :controller

  alias ElixirGoogleScraper.Scraper.Keywords
  alias ElixirGoogleScraperWeb.V1.ErrorView
  alias ElixirGoogleScraperWeb.V1.KeywordView

  def index(conn, params) do
    token = ExOauth2Provider.Plug.current_access_token(conn)
    {keywords, pagination} = Keywords.paginated_user_keywords(token.resource_owner, params)

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

  defp meta_data(pagination) do
    %{
      page: pagination.page,
      pages: pagination.total_pages,
      page_size: pagination.per_page,
      records: pagination.total_count
    }
  end
end
