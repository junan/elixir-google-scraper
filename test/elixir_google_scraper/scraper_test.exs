defmodule ElixirGoogleScraper.ScraperTest do
  use ElixirGoogleScraper.DataCase, async: true

  alias ElixirGoogleScraper.Scraper

  describe "keywords" do
    alias ElixirGoogleScraper.Scraper.Keyword

    @invalid_attrs %{name: nil, status: nil, user_id: nil}

    test "create_keyword/1 with valid data creates a keyword" do
      user = insert(:user)
      valid_attrs = %{name: "some name", status: :pending, user_id: user.id}

      assert {:ok, %Keyword{} = keyword} = Scraper.create_keyword(valid_attrs)
      assert keyword.name == "some name"
      assert keyword.status == :pending
      assert keyword.user_id == user.id
    end

    test "create_keyword/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Scraper.create_keyword(@invalid_attrs)
    end
  end
end
