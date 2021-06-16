defmodule ElixirGoogleScraper.ScraperTest do
  use ElixirGoogleScraper.DataCase, async: true

  alias ElixirGoogleScraper.Scraper
  alias ElixirGoogleScraper.Scraper.Keyword

  describe "create_keyword/1" do
    test "creates a keyword with valid data" do
      user = insert(:user)
      valid_attrs = %{name: "some name", status: :pending, user_id: user.id}

      assert {:ok, %Keyword{} = keyword} = Scraper.create_keyword(valid_attrs)
      assert keyword.name == "some name"
      assert keyword.status == :pending
      assert keyword.user_id == user.id
    end

    test "does not create keyword with invalid data" do
      invalid_attrs = %{name: nil, status: nil, user_id: nil}
      assert {:error, %Ecto.Changeset{}} = Scraper.create_keyword(invalid_attrs)
    end
  end

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
