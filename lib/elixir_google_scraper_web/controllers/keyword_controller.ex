defmodule ElixirGoogleScraperWeb.KeywordController do
  import Ecto.Query, warn: false

  use ElixirGoogleScraperWeb, :controller

  alias ElixirGoogleScraper.Scraper
  alias ElixirGoogleScraper.Repo
  alias ElixirGoogleScraper.Scraper.{CSVKeyword, KeywordScraper, Keyword}

  def index(conn, params) do
    {keywords, pagination} = Scraper.paginated_user_keywords(conn.assigns[:current_user], params)

    keyword = List.first(keywords)

    # keyword
    # |> Keyword.changeset(%{name: Faker.Company.name()})
    # |> Repo.update()

    IO.puts("Starting work ....")
    IO.inspect(keyword.id)
    IO.puts("Finished work")
    # ElixirGoogleScraper.Scraper.Worker.ScrapingWorker

    # ElixirGoogleScraper.Scraper.Worker.ScrapingWorker.new(re)

    job = ElixirGoogleScraper.Scraper.Worker.ScrapingWorker.new(%{keyword_id: 96})

    IO.inspect(job, label: "The job")

    Oban.insert(job)

    render(conn, "index.html", keywords: keywords, pagination: pagination)
  end

  def create(conn, %{"file" => %Plug.Upload{} = file}) do
    {flash_type, flash_message} =
      case Scraper.save_keywords(file, conn.assigns.current_user) do
        {:ok, keyword_ids} ->
          IO.inspect(keyword_ids, label: "Keyword Ids")
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
