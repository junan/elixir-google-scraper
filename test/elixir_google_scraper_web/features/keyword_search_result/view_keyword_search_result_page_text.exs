defmodule ElixirGoogleScraperWeb.KeywordSearchResult.ViewKeywordSearchResultPageTest do
  use ElixirGoogleScraperWeb.FeatureCase, async: true

  feature "views the keyword search result", %{session: session} do
    user = insert(:user)
    keyword = insert(:keyword, user: user, status: :completed)
    insert(:search_result, keyword: keyword)

    session
    |> login_with(user)
    |> visit(Routes.keyword_path(ElixirGoogleScraperWeb.Endpoint, :show, keyword.id))
    |> assert_has(Query.text("Search result report for: #{keyword.name}"))
    |> assert_has(Query.text("Top Advertisers Count"))
    |> assert_has(Query.text("Total Advertisers Count"))
    |> assert_has(Query.text("Total Link Count"))
    |> assert_has(Query.text("Total Result Count"))
    |> assert_has(Query.text("Search Results Urls"))
    |> assert_has(Query.text("Top AdWord Advertisers Urls"))
    |> assert_has(Query.text("Render Search Result HTML"))
  end
end
