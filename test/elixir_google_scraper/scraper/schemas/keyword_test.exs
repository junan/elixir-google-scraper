defmodule ElixirGoogleScraper.Scraper.Schemas.KeywordTest do
  use ElixirGoogleScraper.DataCase, async: true

  alias ElixirGoogleScraper.Scraper.Schemas.Keyword

  describe "changeset/2" do
    test "returns valid changeset if given valid attributes" do
      attrs = %{user_id: insert(:user).id, name: "shopping"}
      changeset = Keyword.changeset(%Keyword{}, attrs)

      assert changeset.valid?
    end

    test "returns invalid changeset if required attributes are missing" do
      changeset = Keyword.changeset(%Keyword{}, %{})

      refute changeset.valid?

      assert errors_on(changeset) == %{
               name: ["can't be blank"],
               user_id: ["can't be blank"]
             }
    end
  end

  describe "complete_changeset/1" do
    test "updates the status from pending to completed in the changeset" do
      keyword = insert(:keyword, status: :pending)
      changeset = Keyword.complete_changeset(keyword)

      assert changeset.changes[:status] == :completed
    end
  end
end
