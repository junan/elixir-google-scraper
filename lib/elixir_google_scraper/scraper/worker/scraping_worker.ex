defmodule ElixirGoogleScraper.Scraper.Worker.ScrapingWorker do
  use Oban.Worker,
    priority: 1,
    max_attempts: 3,
    unique: [period: 30]

  alias ElixirGoogleScraper.Repo
  alias ElixirGoogleScraper.Scraper.{KeywordScraper, Keyword}

  @impl Worker
  def perform(%Oban.Job{args: %{"keyword_id" => keyword_id}}) do
    keyword = Repo.get_by!(Keyword, %{id: keyword_id})

    KeywordScraper.scrap(keyword.name)

    :ok
  end
end
