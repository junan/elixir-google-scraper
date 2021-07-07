defmodule ElixirGoogleScraperWeb.V1.KeywordView do
  use JSONAPI.View, type: "token"

  def fields do
    [
      :name,
      :status,
      :inserted_at
    ]
  end
end
