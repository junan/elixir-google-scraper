defmodule ElixirGoogleScraperWeb.PageControllerTest do
  use ElixirGoogleScraperWeb.ConnCase

  describe "GET index/2" do
    test "renders the welcome message", %{conn: conn} do
      conn = get(conn, "/")
      assert html_response(conn, 200) =~ "Welcome to Google Scraper App"
    end
  end
end
