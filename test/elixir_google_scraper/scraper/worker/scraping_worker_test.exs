defmodule ElixirGoogleScraper.Scraper.Worker.ScrapingWorkerTest do
  use ElixirGoogleScraper.DataCase

  alias ElixirGoogleScraper.Scraper.Worker.ScrapingWorker
  # alias ElixirGoogleScraper.Scraper.SearchResult

  describe "perform/1" do
    test "creates the search result" do
      use_cassette "scraper/keyword_buy_bike" do
        user = insert(:user)
        keyword = insert(:keyword, name: "buy bike", user: user)

        ScrapingWorker.perform(%Oban.Job{args: %{"keyword_id" => keyword.id}})

        # search_result = Repo.reload(keyword).result
        search_result = Repo.preload(keyword, :search_result).search_result

        # assert result.all_ads == []
        # assert result.top_ads == []
        assert search_result.result_count == 10
      end
    end
  end
end
