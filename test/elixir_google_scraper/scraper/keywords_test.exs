defmodule ElixirGoogleScraper.Scraper.KeywordsTest do
  use ElixirGoogleScraper.DataCase, async: true

  alias ElixirGoogleScraper.Scraper.Keywords

  describe "mark_as_completed/1" do
    test "updates the keyword as completed" do
      user = insert(:user)
      keyword = insert(:keyword, status: :pending, user: user)

      result = Keywords.mark_as_completed(keyword)

      assert result.status == :completed
    end
  end
end
