defmodule ElixirGoogleScraperWeb.KeywordSearchResult.ViewHtmlResponsRenderedPageTest do
  use ElixirGoogleScraperWeb.FeatureCase, async: true

  feature "views html response rendered page", %{session: session} do
    user = insert(:user)
    keyword = insert(:keyword, user: user, status: :completed)
    insert(:search_result, keyword: keyword)

    session
    |> login_with(user)
    |> visit(Routes.keyword_html_path(ElixirGoogleScraperWeb.Endpoint, :html, keyword.id))
    |> assert_has(Query.text("Ruby On Rails development service"))
  end
end
