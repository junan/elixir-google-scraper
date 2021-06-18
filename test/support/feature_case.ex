defmodule ElixirGoogleScraperWeb.FeatureCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.Feature

      import ElixirGoogleScraper.Factory

      alias ElixirGoogleScraperWeb.Router.Helpers, as: Routes

      def login(session, email, password) do
        session
        |> visit(Routes.user_session_path(ElixirGoogleScraperWeb.Endpoint, :new))
        |> fill_in(Wallaby.Query.text_field("user_email"), with: email)
        |> fill_in(Wallaby.Query.text_field("user_password"), with: password)
        |> click(Wallaby.Query.button("Login"))
      end

      def login_with_user(session) do
        user = insert(:user)

        login(session, user.email, "secret-password")
      end

      def login_with(session, user) do
        login(session, user.email, "secret-password")
      end
    end
  end
end
