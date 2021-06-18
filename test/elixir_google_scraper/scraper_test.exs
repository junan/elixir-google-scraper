defmodule ElixirGoogleScraper.ScraperTest do
  use ElixirGoogleScraper.DataCase, async: true

  alias ElixirGoogleScraper.Scraper
  alias ElixirGoogleScraper.Scraper.Keyword

  describe "save_keywords/2" do
    test "stores the keywords" do
      user = insert(:user)
      file = %Plug.Upload{content_type: "text/csv", path: "test/fixture/keywords.csv"}

      assert :ok = Scraper.save_keywords(file, user)

      assert [keyword1, keyword2] = Repo.all(Keyword)

      assert keyword1.name == "buy domain"
      assert keyword1.user_id == user.id
      assert keyword1.status == :pending
      assert keyword2.name == "buy bike"
      assert keyword2.user_id == user.id
      assert keyword2.status == :pending
    end
  end

  describe "paginated_user_keywords/2" do
    test "returns only user's keywords" do
      user = insert(:user)
      user2 = insert(:user)
      keyword = insert(:keyword, user: user)
      insert(:keyword, user: user2)

      {keywords, _} = Scraper.paginated_user_keywords(user, %{page: 1})

      assert length(keywords) == 1
      assert List.first(keywords).id == keyword.id
    end

    test "returns user's paginated keywords" do
      user = insert(:user)
      insert_list(13, :keyword, user: user)

      {keywords, _} = Scraper.paginated_user_keywords(user, %{page: 1})

      assert length(keywords) == 12
    end
  end
end
