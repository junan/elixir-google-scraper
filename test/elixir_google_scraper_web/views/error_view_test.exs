defmodule ElixirGoogleScraperWeb.ErrorViewTest do
  use ElixirGoogleScraperWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.html" do
    assert render_to_string(ElixirGoogleScraperWeb.ErrorView, "404.html", []) =~
             "The page you are looking for was not found."
  end

  test "renders 500.html" do
    assert render_to_string(ElixirGoogleScraperWeb.ErrorView, "500.html", []) ==
             "Internal Server Error"
  end
end
