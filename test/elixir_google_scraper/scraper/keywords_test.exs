defmodule ElixirGoogleScraper.Scraper.KeywordsTest do
  use ElixirGoogleScraper.DataCase, async: true

  alias ElixirGoogleScraper.Scraper.Keywords
  alias ElixirGoogleScraper.Scraper.Schemas.Keyword

  describe "mark_as_completed/1" do
    test "updates the keyword as completed" do
      user = insert(:user)
      keyword = insert(:keyword, status: :pending, user: user)

      result = Keywords.mark_as_completed(keyword)

      assert result.status == :completed
    end
  end

  describe "save_keywords/2" do
    test "stores the keywords" do
      user = insert(:user)
      file = %Plug.Upload{content_type: "text/csv", path: "test/fixture/keywords.csv"}

      assert :ok = Keywords.save_keywords(file, user)

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

      {keywords, _} = Keywords.paginated_user_keywords(user, %{page: 1})

      assert length(keywords) == 1
      assert List.first(keywords).id == keyword.id
    end

    test "returns user's paginated keywords" do
      user = insert(:user)
      insert_list(13, :keyword, user: user)

      {keywords, _} = Keywords.paginated_user_keywords(user, %{page: 1})

      assert length(keywords) == 12
    end

    test "returns filtered user's keywords when the query string is available" do
      user = insert(:user)
      insert_list(2, :keyword, user: user)
      keyword = insert(:keyword, name: "shopping", user: user)

      {keywords, _} = Keywords.paginated_user_keywords(user, %{"name" => "shopping", page: 1})

      assert List.first(keywords).id == keyword.id
    end
  end

  describe "get_keyword/1" do
    test "returns the keyword with preloded search result when the ID is valid" do
      user = insert(:user)
      keyword = insert(:keyword, user: user)
      search_result = insert(:search_result, keyword: keyword)

      result = Keywords.get_keyword(keyword.id)

      assert result.id == keyword.id
      assert result.search_result.id == search_result.id
    end

    test "returns nil when the ID is invalid" do
      user = insert(:user)
      keyword = insert(:keyword, user: user)

      result = Keywords.get_keyword(keyword.id + 1)

      assert result == nil
    end
  end
end
