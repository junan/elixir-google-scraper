defmodule ElixirGoogleScraper.Scraper.Keyword do
  use Ecto.Schema
  import Ecto.Changeset

  alias ElixirGoogleScraper.Accounts.User

  schema "keywords" do
    field :name, :string
    field :status, Ecto.Enum, values: [pending: 0, failed: 1, completed: 2]
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(keyword, attrs) do
    keyword
    |> cast(attrs, [:name, :status, :user_id])
    |> validate_required([:name, :status, :user_id])
  end
end
