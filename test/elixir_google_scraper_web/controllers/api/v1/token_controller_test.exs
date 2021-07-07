defmodule ElixirGoogleScraperWeb.Api.V1.TokenControllerTest do
  use ElixirGoogleScraperWeb.ConnCase, async: true

  alias ExOauth2Provider.Applications

  describe "POST create/2" do
    test "returns the token when the credentials are valid", %{conn: conn} do
      password = "secret-password"
      user = insert(:user, password: password)
      attrs = %{name: "Application", redirect_uri: "https://example.org/endpoint"}

      {:ok, application} =
        Applications.create_application(nil, attrs, otp_app: :elixir_google_scraper)

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("accept", "application/json")
        |> post(Routes.api_v1_token_path(conn, :create), %{
          username: user.email,
          password: password,
          grant_type: "password",
          client_id: application.uid,
          client_secret: application.secret
        })

      assert %{
               "data" => %{
                 "attributes" => %{
                   "access_token" => _,
                   "created_at" => _,
                   "expires_in" => 7200,
                   "token_type" => "bearer"
                 },
                 "id" => _,
                 "relationships" => %{},
                 "type" => "token"
               },
               "included" => []
             } = json_response(conn, 200)
    end

    test "returns an error when the credentials are invalid", %{conn: conn} do
      insert(:user, password: "secret-password")
      attrs = %{name: "Application", redirect_uri: "https://example.org/endpoint"}

      {:ok, application} =
        Applications.create_application(nil, attrs, otp_app: :elixir_google_scraper)

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("accept", "application/json")
        |> post(Routes.api_v1_token_path(conn, :create), %{
          username: "invalid",
          password: "invalid",
          grant_type: "password",
          client_id: application.uid,
          client_secret: application.secret
        })

      assert json_response(conn, 422) == %{
               "errors" => [%{"detail" => "Authentiocation failed"}]
             }
    end
  end
end
