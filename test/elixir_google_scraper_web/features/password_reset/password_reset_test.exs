defmodule ElixirGoogleScraperWeb.PasswordReset.PasswordResetTest do
  use ElixirGoogleScraperWeb.FeatureCase

  @path Routes.user_settings_path(ElixirGoogleScraperWeb.Endpoint, :edit)

  feature "updates the new password successfully", %{session: session} do
    session
    |> login_with_user
    |> visit(@path)
    |> fill_in(Query.css("#user_password"), with: "new-secret-password")
    |> fill_in(Query.css("#user_password_confirmation"), with: "new-secret-password")
    |> fill_in(Query.css("#current_password_for_password"), with: "secret-password")
    |> click(Query.button("Change password"))
    |> assert_has(Query.text("Password updated successfully."))
  end
end
