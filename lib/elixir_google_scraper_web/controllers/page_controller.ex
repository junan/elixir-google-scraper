defmodule ElixirGoogleScraperWeb.PageController do
  use ElixirGoogleScraperWeb, :controller

  plug(:redirect_to_dashboard_if_signed_in, [] when action in [:index])

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def redirect_to_dashboard_if_signed_in(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
      |> redirect(to: "/keywords")
      |> halt()
    else
      conn
    end
  end
end
