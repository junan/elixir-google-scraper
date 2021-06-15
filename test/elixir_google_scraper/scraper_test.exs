defmodule ElixirGoogleScraper.ScraperTest do
  use ElixirGoogleScraper.DataCase

  alias ElixirGoogleScraper.Scraper

  describe "keywords" do
    alias ElixirGoogleScraper.Scraper.Keyword

    @valid_attrs %{name: "some name", status: "some status", user_id: "some user_id"}
    @update_attrs %{
      name: "some updated name",
      status: "some updated status",
      user_id: "some updated user_id"
    }
    @invalid_attrs %{name: nil, status: nil, user_id: nil}

    def keyword_fixture(attrs \\ %{}) do
      {:ok, keyword} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Scraper.create_keyword()

      keyword
    end

    test "list_keywords/0 returns all keywords" do
      keyword = keyword_fixture()
      assert Scraper.list_keywords() == [keyword]
    end

    test "get_keyword!/1 returns the keyword with given id" do
      keyword = keyword_fixture()
      assert Scraper.get_keyword!(keyword.id) == keyword
    end

    test "create_keyword/1 with valid data creates a keyword" do
      assert {:ok, %Keyword{} = keyword} = Scraper.create_keyword(@valid_attrs)
      assert keyword.name == "some name"
      assert keyword.status == "some status"
      assert keyword.user_id == "some user_id"
    end

    test "create_keyword/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Scraper.create_keyword(@invalid_attrs)
    end

    test "update_keyword/2 with valid data updates the keyword" do
      keyword = keyword_fixture()
      assert {:ok, %Keyword{} = keyword} = Scraper.update_keyword(keyword, @update_attrs)
      assert keyword.name == "some updated name"
      assert keyword.status == "some updated status"
      assert keyword.user_id == "some updated user_id"
    end

    test "update_keyword/2 with invalid data returns error changeset" do
      keyword = keyword_fixture()
      assert {:error, %Ecto.Changeset{}} = Scraper.update_keyword(keyword, @invalid_attrs)
      assert keyword == Scraper.get_keyword!(keyword.id)
    end

    test "delete_keyword/1 deletes the keyword" do
      keyword = keyword_fixture()
      assert {:ok, %Keyword{}} = Scraper.delete_keyword(keyword)
      assert_raise Ecto.NoResultsError, fn -> Scraper.get_keyword!(keyword.id) end
    end

    test "change_keyword/1 returns a keyword changeset" do
      keyword = keyword_fixture()
      assert %Ecto.Changeset{} = Scraper.change_keyword(keyword)
    end
  end
end
