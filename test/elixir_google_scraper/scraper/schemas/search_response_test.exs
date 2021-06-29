defmodule ElixirGoogleScraper.Scraper.Schemas.SearchResultTest do
  use ElixirGoogleScraper.DataCase, async: true

  alias ElixirGoogleScraper.Scraper.Schemas.SearchResult

  describe "changeset/2" do
    @valid_attrs %{total_links_count: 200, result_count: 10, html: "<html></html>"}

    test "requires the result_count" do
      attr = Map.put(@valid_attrs, :keyword_id, insert(:keyword).id)

      changeset = SearchResult.changeset(%SearchResult{}, Map.delete(attr, :result_count))

      refute changeset.valid?
    end

    test "requires the total_links_count" do
      attr = Map.put(@valid_attrs, :keyword_id, insert(:keyword).id)

      changeset = SearchResult.changeset(%SearchResult{}, Map.delete(attr, :total_links_count))

      refute changeset.valid?
    end

    test "requires the html" do
      attr = Map.put(@valid_attrs, :keyword_id, insert(:keyword).id)

      changeset = SearchResult.changeset(%SearchResult{}, Map.delete(attr, :html))

      refute changeset.valid?
    end

    test "requires the keyword_id" do
      changeset = SearchResult.changeset(%SearchResult{}, @valid_attrs)

      refute changeset.valid?
    end
  end
end
