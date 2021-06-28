defmodule ElixirGoogleScraper.Scraper.Keyword do
  use Ecto.Schema
  import Ecto.Changeset

  alias ElixirGoogleScraper.Accounts.User
  alias ElixirGoogleScraper.Repo
  alias ElixirGoogleScraper.Scraper.{Keyword, SearchResult}

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

  def mark_as_completed(keyword) do
    keyword
    |> Keyword.changeset(%{status: :completed})
    |> Repo.update!()
  end
end
