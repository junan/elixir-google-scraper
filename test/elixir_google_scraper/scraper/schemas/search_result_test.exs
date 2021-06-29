defmodule ElixirGoogleScraper.Scraper.Schemas.SearchResultTest do
  use ElixirGoogleScraper.DataCase, async: true

  alias ElixirGoogleScraper.Repo
  alias ElixirGoogleScraper.Scraper.Schemas.SearchResult

  describe "changeset/2" do
    test "returns valid changeset if given valid attributes" do
      attrs = %{
        total_links_count: 200,
        result_urls: ["https://example.com"],
        result_count: 10,
        html: "<html></html>",
        keyword_id: insert(:keyword).id
      }

      changeset = SearchResult.changeset(%SearchResult{}, attrs)

      assert changeset.valid?
    end

    test "returns invalid changeset if required attributes are missing" do
      changeset = SearchResult.changeset(%SearchResult{}, %{})

      refute changeset.valid?

      assert errors_on(changeset) == %{
               html: ["can't be blank"],
               keyword_id: ["can't be blank"],
               result_count: ["can't be blank"],
               total_links_count: ["can't be blank"],
               result_urls: ["can't be blank"]
             }
    end

    test "returns invalid changeset if keyword does not exist" do
      attrs = %{
        total_links_count: 200,
        result_urls: ["https://example.com"],
        result_count: 10,
        html: "<html></html>",
        keyword_id: 1000
      }

      changeset = SearchResult.changeset(%SearchResult{}, attrs)

      assert {:error, changeset} = Repo.insert(changeset)
      refute changeset.valid?
      assert errors_on(changeset) == %{keyword: ["does not exist"]}
    end
  end
end
