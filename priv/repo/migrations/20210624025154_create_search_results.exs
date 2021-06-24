defmodule ElixirGoogleScraper.Repo.Migrations.CreateSearchResults do
  use Ecto.Migration

  def change do
    create table(:search_results) do
      add :top_ads_count, :integer
      add :top_ads_urls, {:array, :string}
      add :total_ads_count, :integer
      add :result_count, :integer
      add :result_urls, {:array, :string}
      add :total_links_count, :integer
      add :html, :text
      add :keyword_id, references(:keywords, on_delete: :nothing)

      timestamps()
    end

    create index(:search_results, [:keyword_id])
  end
end
