defmodule ElixirGoogleScraperWeb.V1.KeywordView do
  use JSONAPI.View, type: "keyword"

  def fields do
    [
      :name,
      :status,
      :inserted_at
    ]
  end
end
