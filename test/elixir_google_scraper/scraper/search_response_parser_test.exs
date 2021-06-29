defmodule ElixirGoogleScraper.Scraper.SearchResponseParserTest do
  use ElixirGoogleScraper.DataCase, async: true

  alias ElixirGoogleScraper.Scraper.SearchResponseParser

  describe "parse/1" do
    test "returns parsed data" do
      {_, html} = File.read("test/fixture/html.html")

      result = SearchResponseParser.parse(html)

      assert result.top_ads_count == 1
      assert result.top_ads_urls == ["https://nimblehq.co/"]
      assert result.total_ads_count == 1
      assert Enum.count(result.result_urls) == 1
      assert result.total_links_count == 2
      assert String.contains?(result.html, "<!DOCTYPE html>")
    end
  end
end
