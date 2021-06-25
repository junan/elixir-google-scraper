defmodule ElixirGoogleScraper.Scraper.Worker.ScrapingWorkerTest do
  use ElixirGoogleScraper.DataCase, async: true

  alias ElixirGoogleScraper.Scraper.Worker.ScrapingWorker

  describe "perform/1" do
    test "creates the search result" do
      use_cassette "scraper/keyword_buy_bike" do
        user = insert(:user)
        keyword = insert(:keyword, name: "buy bike", user: user)

        ScrapingWorker.perform(%Oban.Job{args: %{"keyword_id" => keyword.id}})

        search_result = Repo.preload(keyword, :search_result).search_result

        assert search_result.top_ads_count == 1
        assert search_result.top_ads_urls == ["https://www.bsrbikeshop.com/"]
        assert search_result.total_ads_count == 1
        assert Enum.count(search_result.result_urls) == 10
        assert search_result.total_links_count == 152
        assert search_result.keyword_id == keyword.id
        assert String.contains?(search_result.html, "<!doctype html>")
      end
    end

    test "updates the keyword as completed" do
      use_cassette "scraper/keyword_buy_bike" do
        user = insert(:user)
        keyword = insert(:keyword, name: "buy bike", user: user)

        ScrapingWorker.perform(%Oban.Job{args: %{"keyword_id" => keyword.id}})

        keyword = Repo.reload(keyword)

        assert keyword.status == :completed
      end
    end
  end
end
