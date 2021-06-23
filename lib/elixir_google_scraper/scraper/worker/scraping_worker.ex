defmodule ElixirGoogleScraper.Scraper.Worker.ScrapingWorker do
  use Oban.Worker,
    priority: 1,
    max_attempts: 3,
    unique: [period: 30]

  alias ElixirGoogleScraper.Repo
  alias ElixirGoogleScraper.Scraper.{CSVKeyword, KeywordScraper, Keyword}

  @impl Worker
  def perform(%Oban.Job{args: %{"keyword_id" => keyword_id}}) do
    keyword = Repo.get_by!(Keyword, %{id: keyword_id})

    keyword
    |> Keyword.changeset(%{name: Faker.Company.name(), status: :completed})
    |> Repo.update()

    :ok
  end
end
