defmodule ElixirGoogleScraperWeb.Api.ErrorHandler do
  use ElixirGoogleScraperWeb, :controller

  alias ElixirGoogleScraperWeb.V1.ErrorView

  def unauthenticated(conn, _) do
    conn
    |> put_status(:unauthorized)
    |> render(ErrorView, "error.json", errors: [%{detail: "Authentication failed"}])
  end
end
