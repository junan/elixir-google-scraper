defmodule ElixirGoogleScraperWeb.KeywordController do
  use ElixirGoogleScraperWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
