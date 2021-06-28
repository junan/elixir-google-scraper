defmodule ElixirGoogleScraper.Scraper.Worker.ScrapingWorker do
  use Oban.Worker,
    priority: 1,
    max_attempts: 10,
    unique: [period: 30]

  alias ElixirGoogleScraper.Repo
  alias ElixirGoogleScraper.Scraper.{Keyword, KeywordScraper, SearchResult}

  @impl Worker
  def perform(%Oban.Job{args: %{"keyword_id" => keyword_id}}) do
    keyword = Repo.get_by!(Keyword, %{id: keyword_id})

    # Scraping google search result and storing the parsed result
    keyword.name
    |> KeywordScraper.scrape()
    |> SearchResult.changeset(%{keyword_id: keyword.id})
    |> Repo.insert!()

    # Updating keyword status as completed
    _ = Keyword.mark_as_completed(keyword)

    :ok
  end
end
