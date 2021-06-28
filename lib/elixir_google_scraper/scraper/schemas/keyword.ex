defmodule ElixirGoogleScraper.Scraper.Schemas.Keyword do
  use Ecto.Schema
  import Ecto.Changeset

  alias ElixirGoogleScraper.Accounts.User
  alias ElixirGoogleScraper.Scraper.SearchResult

  schema "keywords" do
    field(:name, :string)
    field(:status, Ecto.Enum, values: [pending: 0, failed: 1, completed: 2])

    belongs_to(:user, User)
    has_one(:search_result, SearchResult)

    timestamps()
  end

  @doc false
  def changeset(keyword, attrs) do
    keyword
    |> cast(attrs, [:name, :status, :user_id])
    |> validate_required([:name, :user_id])
  end

  def complete_changeset(keyword) do
    change(keyword, %{status: :completed})
  end
end
