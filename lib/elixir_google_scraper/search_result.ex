defmodule ElixirGoogleScraper.SearchResult do
  use Ecto.Schema
  import Ecto.Changeset

  schema "search_results" do
    field(:html, :string)
    field(:result_count, :integer)
    field(:result_urls, {:array, :string})
    field(:top_ads_count, :integer)
    field(:top_ads_urls, {:array, :string})
    field(:total_ads_count, :integer)
    field(:total_links_count, :integer)
    field(:keyword_id, :id)

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
      :html
    ])
    |> validate_required([:result_count, :result_urls, :total_links_count, :html])
  end
end
