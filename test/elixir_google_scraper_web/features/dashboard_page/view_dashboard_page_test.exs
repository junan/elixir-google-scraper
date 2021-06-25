defmodule ElixirGoogleScraperWeb.DashboardPage.ViewDashBoardPageTest do
  use ElixirGoogleScraperWeb.FeatureCase

  @path Routes.keyword_path(ElixirGoogleScraperWeb.Endpoint, :index)

  feature "views dashboard page", %{session: session} do
    user = insert(:user)
    keyword = insert(:keyword, user: user)

    session
    |> login_with(user)
    |> visit(@path)
    |> assert_has(Query.text(keyword.name))
  end
end
