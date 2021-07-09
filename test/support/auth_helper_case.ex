defmodule ElixirGoogleScraperWeb.AuthHelperCase do
  import Plug.Conn

  alias ElixirGoogleScraper.Account.Users
  alias ExOauth2Provider.AccessTokens
  alias ExOauth2Provider.Applications

  def authenticated_api_conn(conn, user) do
    attrs = %{name: "Application", redirect_uri: "https://example.org/endpoint"}

    {_, oauth_app} = Applications.create_application(nil, attrs, otp_app: :elixir_google_scraper)

    {_, access_token} =
      AccessTokens.create_token(
        user,
        %{application: oauth_app},
        otp_app: :elixir_google_scraper
      )

    put_req_header(conn, "authorization", "Bearer " <> access_token.token)
  end

  @doc """
  Setup helper that registers and logs in users.

      setup :register_and_log_in_user

  It stores an updated connection and a registered user in the
  test context.
  """
  def register_and_log_in_user(%{conn: conn}) do
    user = ElixirGoogleScraper.AccountsFixtures.user_fixture()
    %{conn: log_in_user(conn, user), user: user}
  end

  @doc """
  Logs the given `user` into the `conn`.

  It returns an updated `conn`.
  """
  def log_in_user(conn, user) do
    token = Users.generate_user_session_token(user)

    conn
    |> Phoenix.ConnTest.init_test_session(%{})
    |> Plug.Conn.put_session(:user_token, token)
  end
end
