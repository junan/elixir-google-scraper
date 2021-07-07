defmodule ElixirGoogleScraperWeb.V1.KeywordSearchResultView do
  use JSONAPI.View, type: "keyword_search_result"

  def fields do
    [
      :top_ads_count,
      :top_ads_urls,
      :total_ads_count,
      :result_count,
      :result_urls,
      :total_links_count,
      :html,
      :inserted_at
    ]
  end
end
