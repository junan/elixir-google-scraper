defmodule ElixirGoogleScraper.Scraper.KeywordTest do
  use ElixirGoogleScraper.DataCase, async: true

  alias ElixirGoogleScraper.Scraper.Keyword

  describe "mark_as_completed/1" do
    test "updates the keyword as completed" do
      user = insert(:user)
      keyword = insert(:keyword, status: :pending, user: user)

      result = Keyword.mark_as_completed(keyword)

      assert result.status == :completed
    end
  end
end
