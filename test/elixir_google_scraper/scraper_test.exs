defmodule ElixirGoogleScraper.ScraperTest do
  use ElixirGoogleScraper.DataCase, async: true

  alias ElixirGoogleScraper.Scraper
  alias ElixirGoogleScraper.Scraper.Keyword

  describe "save_keywords/2" do
    test "stores the keywords" do
      user = insert(:user)
      file = %Plug.Upload{content_type: "text/csv", path: "test/fixture/keywords.csv"}

      assert {:ok, :file_is_proccessed} = Scraper.save_keywords(file, user)

      assert [keyword1, keyword2] = Repo.all(Keyword)

      assert keyword1.name == "buy domain"
      assert keyword1.user_id == user.id
      assert keyword1.status == :pending
      assert keyword2.name == "buy bike"
      assert keyword2.user_id == user.id
      assert keyword2.status == :pending
    end
  end
end
