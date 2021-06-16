defmodule ElixirGoogleScraperWeb.PageControllerTest do
  use ElixirGoogleScraperWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to Google Scaraper App"
  end
end
