defmodule ElixirGoogleScraperWeb.LoginPage.ViewLoginPageTest do
  use ElixirGoogleScraperWeb.FeatureCase, async: true

  @path Routes.user_session_path(ElixirGoogleScraperWeb.Endpoint, :new)

  feature "views login page", %{session: session} do
    session
    |> visit(@path)
    |> assert_has(Query.text("Log in", count: 3))
  end

  feature "logins with valid credential", %{session: session} do
    email = "john@example.com"
    attrs = %{email: email}
    insert(:user, attrs)

    session
    |> visit(@path)
    |> fill_in(Query.text_field("Email"), with: email)
    |> fill_in(Query.css("#user_password"), with: "secret-password")
    |> click(Query.button("Log in"))
    |> assert_has(Query.text("Log out"))
  end

  feature "logins with INVALID credential", %{session: session} do
    email = "john@example.com"
    attrs = %{email: email}
    insert(:user, attrs)

    session
    |> visit(@path)
    |> fill_in(Query.text_field("Email"), with: email)
    |> fill_in(Query.css("#user_password"), with: "invalid")
    |> click(Query.button("Log in"))
    |> assert_has(Query.text("Invalid email or password"))
  end
end
