defmodule ElixirGoogleScraper.Repo.Migrations.CreateKeywords do
  use Ecto.Migration

  def change do
    create table(:keywords) do
      add :name, :string, null: false
      add :status, :integer, default: 0, null: false
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

  end
end
