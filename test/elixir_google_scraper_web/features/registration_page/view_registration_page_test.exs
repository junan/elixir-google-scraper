defmodule ElixirGoogleScraperWeb.RegistrationPage.ViewRegistrationPageTest do
  use ElixirGoogleScraperWeb.FeatureCase, async: true

  @path Routes.user_registration_path(ElixirGoogleScraperWeb.Endpoint, :new)

  feature "views registration page", %{session: session} do
    session
    |> visit(@path)
    |> assert_has(Query.text("Register"))
  end

  feature "registers a new user with valid attributes", %{session: session} do
    session
    |> visit(@path)
    |> fill_in(Query.text_field("Email"), with: "john@example.com")
    |> fill_in(Query.css("#user_password"), with: "secret-password")
    |> click(Query.button("Register"))
    |> assert_has(Query.text("User created successfully."))
  end

  feature "registers a new user with INVALID attribute", %{session: session} do
    session
    |> visit(@path)
    |> fill_in(Query.text_field("Email"), with: "john@example.com")
    |> fill_in(Query.css("#user_password"), with: "invalid")
    |> click(Query.button("Register"))
    |> assert_has(Query.text("should be at least 12 character(s)"))
  end
end
