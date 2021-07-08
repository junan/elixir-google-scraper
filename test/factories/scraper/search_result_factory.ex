defmodule ElixirGoogleScraper.Scraper.SearchResultFactory do
  defmacro __using__(_opts) do
    quote do
      def search_result_factory do
        %ElixirGoogleScraper.Scraper.Schemas.SearchResult{
          result_count: 1,
          result_urls: ["https://nimblehq.co/"],
          top_ads_count: 0,
          top_ads_urls: [],
          total_ads_count: 0,
          total_links_count: 10,
          html:
            "<!DOCTYPE html><a href='https://nimblehq.co/'>Ruby On Rails development service</a></html>",
          keyword: build(:keyword)
        }
      end
    end
  end
end
