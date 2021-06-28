defmodule ElixirGoogleScraper.Scraper.SearchResult do
  use Ecto.Schema
  import Ecto.Changeset

  alias ElixirGoogleScraper.Scraper.Schemas.Keyword

  schema "search_results" do
    field(:html, :string)
    field(:result_count, :integer)
    field(:result_urls, {:array, :string})
    field(:top_ads_count, :integer)
    field(:top_ads_urls, {:array, :string})
    field(:total_ads_count, :integer)
    field(:total_links_count, :integer)

    belongs_to(:keyword, Keyword)

    timestamps()
  end

  @doc false
  def changeset(search_result, attrs) do
    search_result
    |> cast(attrs, [
      :top_ads_count,
      :top_ads_urls,
      :total_ads_count,
      :result_count,
      :result_urls,
      :total_links_count,
      :html,
      :keyword_id
    ])
    |> validate_required([:result_count, :total_links_count, :html, :keyword_id])
    |> assoc_constraint(:keyword)
  end
end
