defmodule ElixirGoogleScraperWeb.Api.V1.KeywordControllerTest do
  use ElixirGoogleScraperWeb.ConnCase, async: true

  alias ExOauth2Provider.AccessTokens
  alias ExOauth2Provider.Applications

  describe "POST create/2" do
    test "returrns 201 status with empty body when the token is valid", %{conn: conn} do
      user = insert(:user)
      attrs = %{name: "Application", redirect_uri: "https://example.org/endpoint"}
      file = %Plug.Upload{content_type: "text/csv", path: "test/fixture/keywords.csv"}

      {_, oauth_app} = Applications.create_application(nil, attrs, otp_app: :elixir_google_scraper)

      {_, acess_token} =
        AccessTokens.create_token(user, %{application: oauth_app}, otp_app: :elixir_google_scraper)

      conn =
        conn
        |> put_req_header("authorization", "Bearer " <> acess_token.token)
        |> post(Routes.api_v1_keyword_path(conn, :create), %{file: file})

      assert conn.status == 201
      assert conn.resp_body == ""
    end

    test "returrns 401 status with an error when the token is invalid", %{conn: conn} do
      file = %Plug.Upload{content_type: "text/csv", path: "test/fixture/keywords.csv"}

      conn =
        conn
        |> put_req_header("authorization", "Bearer " <> "invalid-token")
        |> post(Routes.api_v1_keyword_path(conn, :create), %{file: file})

      assert json_response(conn, 401) == %{
               "errors" => [%{"detail" => "Authentication failed"}]
             }
    end

    test "returrns 422 status with an error when keywords are empty", %{conn: conn} do
      user = insert(:user)
      attrs = %{name: "Application", redirect_uri: "https://example.org/endpoint"}
      file = %Plug.Upload{content_type: "text/csv", path: "test/fixture/empty_keywords.csv"}

      {_, oauth_app} = Applications.create_application(nil, attrs, otp_app: :elixir_google_scraper)

      {_, acess_token} =
        AccessTokens.create_token(user, %{application: oauth_app}, otp_app: :elixir_google_scraper)

      conn =
        conn
        |> put_req_header("authorization", "Bearer " <> acess_token.token)
        |> post(Routes.api_v1_keyword_path(conn, :create), %{file: file})

      assert json_response(conn, 422) == %{
               "errors" => [%{"detail" => "File cant be empty"}]
             }
    end

    test "returrns 422 status with an error when keywords are more than 1000", %{conn: conn} do
      user = insert(:user)
      attrs = %{name: "Application", redirect_uri: "https://example.org/endpoint"}
      file = %Plug.Upload{content_type: "text/csv", path: "test/fixture/large_keywords.csv"}

      {_, oauth_app} = Applications.create_application(nil, attrs, otp_app: :elixir_google_scraper)

      {_, acess_token} =
        AccessTokens.create_token(user, %{application: oauth_app}, otp_app: :elixir_google_scraper)

      conn =
        conn
        |> put_req_header("authorization", "Bearer " <> acess_token.token)
        |> post(Routes.api_v1_keyword_path(conn, :create), %{file: file})

      assert json_response(conn, 422) == %{
               "errors" => [%{"detail" => "CSV Keywords count can't be more than 1000"}]
             }
    end
  end
end
