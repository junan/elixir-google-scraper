defmodule ElixirGoogleScraperWeb.HomePage.ViewHomePageTest do
  use ElixirGoogleScraperWeb.FeatureCase

  feature "view home page", %{session: session} do
    visit(session, Routes.page_path(ElixirGoogleScraperWeb.Endpoint, :index))

    assert_has(session, Query.text("Welcome to Phoenix!"))
  end
end
