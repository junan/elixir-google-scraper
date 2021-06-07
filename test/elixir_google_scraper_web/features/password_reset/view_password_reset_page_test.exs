defmodule ElixirGoogleScraperWeb.PasswordReset.ViewPasswordResetPageTest do
  use ElixirGoogleScraperWeb.FeatureCase, async: true

  @path Routes.user_settings_path(ElixirGoogleScraperWeb.Endpoint, :edit)

  feature "views password reset page", %{session: session} do
    session
    |> login_with_user
    |> visit(@path)
    |> assert_has(Query.text("Change your password"))
  end
end
