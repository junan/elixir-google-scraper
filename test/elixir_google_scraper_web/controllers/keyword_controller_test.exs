defmodule ElixirGoogleScraperWeb.KeywordControllerTest do
  use ElixirGoogleScraperWeb.ConnCase, async: true

  describe "GET index/2" do
    test "returns 200 status code when accessing with a logged-in user", %{conn: conn} do
      user = insert(:user)

      conn =
        conn
        |> log_in_user(user)
        |> get(Routes.keyword_path(conn, :index))

      assert html_response(conn, 200) =~ "Upload"
      assert html_response(conn, 200) =~ "You have not performed any google search yet"
    end
  end

  describe "POST create/2" do
    test "redirects to the keywords index page when the CVS file uploaded successfully", %{
      conn: conn
    } do
      file = %Plug.Upload{content_type: "text/csv", path: "test/fixture/keywords.csv"}
      user = insert(:user)
      params = %{:file => file}

      conn =
        conn
        |> log_in_user(user)
        |> post(Routes.keyword_path(conn, :create), params)

      assert redirected_to(conn) == Routes.keyword_path(conn, :index)
      assert get_flash(conn, :info) == "Your CSV file has been uploaded successfully"
    end
  end

  test "renders error message when CVS file is empty", %{
    conn: conn
  } do
    file = %Plug.Upload{content_type: "text/csv", path: "test/fixture/empty_keywords.csv"}
    user = insert(:user)
    params = %{:file => file}

    conn =
      conn
      |> log_in_user(user)
      |> post(Routes.keyword_path(conn, :create), params)

    assert redirected_to(conn) == Routes.keyword_path(conn, :index)
    assert get_flash(conn, :error) == "File can't be blank"
  end
end
