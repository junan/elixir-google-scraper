defmodule ElixirGoogleScraperWeb.V1.TokenView do
  use JSONAPI.View, type: "token"

  def fields do
    [
      :access_token,
      :expires_in,
      :created_at,
      :token_type
    ]
  end

  def type, do: "not-included"
end
