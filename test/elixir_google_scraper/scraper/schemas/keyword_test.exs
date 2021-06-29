defmodule ElixirGoogleScraper.Scraper.Schemas.KeywordTest do
  use ElixirGoogleScraper.DataCase, async: true

  alias ElixirGoogleScraper.Scraper.Schemas.Keyword

  describe "changeset/2" do
    test "requires the name" do
      attrs = %{user_id: insert(:user).id}
      changeset = Keyword.changeset(%Keyword{}, attrs)

      refute changeset.valid?
    end

    test "requires the user_id" do
      attrs = %{name: "shopping"}
      changeset = Keyword.changeset(%Keyword{}, attrs)

      refute changeset.valid?
    end
  end

  describe "complete_changeset/1" do
    test "updates the status from pending to completed in the changese" do
      keyword = insert(:keyword, status: :pending)
      changeset = Keyword.complete_changeset(keyword)

      assert changeset.changes[:status] == :completed
    end
  end
end
