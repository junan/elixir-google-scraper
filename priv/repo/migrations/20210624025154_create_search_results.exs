defmodule ElixirGoogleScraper.Repo.Migrations.CreateSearchResults do
  use Ecto.Migration

  def change do
    create table(:search_results) do
      add(:top_ads_count, :integer, null: false, default: 0)
      add(:top_ads_urls, {:array, :string})
      add(:total_ads_count, :integer, null: false, default: 0)
      add(:result_count, :integer, null: false, default: 0)
      add(:result_urls, {:array, :string}, null: false)
      add(:total_links_count, :integer, null: false, default: 0)
      add(:html, :text, null: false)
      add(:keyword_id, references(:keywords, on_delete: :nothing), null: false)

      timestamps()
    end

    create(index(:search_results, [:keyword_id]))
  end
end
