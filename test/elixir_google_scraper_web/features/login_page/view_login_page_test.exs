defmodule ElixirGoogleScraperWeb.LoginPage.ViewLoginPageTest do
  use ElixirGoogleScraperWeb.FeatureCase

  @path Routes.user_session_path(ElixirGoogleScraperWeb.Endpoint, :new)

  feature "views login page", %{session: session} do
    session
    |> visit(@path)
    |> assert_has(Query.text("Login to your account"))
  end

  feature "logins with valid credential", %{session: session} do
    email = "john@example.com"
    attrs = %{email: email}
    insert(:user, attrs)

    session
    |> visit(@path)
    |> fill_in(Query.text_field("Email"), with: email)
    |> fill_in(Query.css("#user_password"), with: "secret-password")
    |> click(Query.button("Login"))
    |> assert_has(Query.text("Logout"))
  end

  feature "logins with INVALID credential", %{session: session} do
    email = "john@example.com"
    attrs = %{email: email}
    insert(:user, attrs)

    session
    |> visit(@path)
    |> fill_in(Query.text_field("Email"), with: email)
    |> fill_in(Query.css("#user_password"), with: "invalid")
    |> click(Query.button("Login"))
    |> assert_has(Query.text("Invalid email or password"))
  end
end
