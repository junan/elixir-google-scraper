defmodule ElixirGoogleScraperWeb.KeywordControllerTest do
  use ElixirGoogleScraperWeb.ConnCase, async: true

  alias ElixirGoogleScraper.Scraper.Schemas.Keyword

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

    test "renders error message when CSV file is empty", %{
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

  describe "GET show/2" do
    test "returns 200 status code", %{conn: conn} do
      user = insert(:user)
      keyword = insert(:keyword, user: user, status: :completed)
      insert(:search_result, keyword: keyword)

      conn =
        conn
        |> log_in_user(user)
        |> get(Routes.keyword_path(conn, :show, keyword.id))

      assert html_response(conn, 200) =~ keyword.name
    end

    test "assigns the keyword", %{conn: conn} do
      user = insert(:user)
      keyword = insert(:keyword, user: user, status: :completed)
      insert(:search_result, keyword: keyword)
      keyword_id = keyword.id

      conn =
        conn
        |> log_in_user(user)
        |> get(Routes.keyword_path(conn, :show, keyword_id))

      assert %Keyword{id: ^keyword_id} = conn.assigns[:keyword]
    end

    test "redirects to the keywords dashboad page if the keyword is not found", %{conn: conn} do
      user = insert(:user)

      conn =
        conn
        |> log_in_user(user)
        |> get(Routes.keyword_path(conn, :show, 100))

      assert redirected_to(conn) == "/keywords"
    end
  end

  describe "GET html/2" do
    test "returns 200 status code", %{conn: conn} do
      user = insert(:user)
      keyword = insert(:keyword, user: user, status: :completed)
      insert(:search_result, keyword: keyword)

      conn =
        conn
        |> log_in_user(user)
        |> get(Routes.keyword_html_path(conn, :html, keyword.id))

      assert html_response(conn, 200) =~ "https://nimblehq.co/"
    end

    test "assigns the keyword", %{conn: conn} do
      user = insert(:user)
      keyword = insert(:keyword, user: user, status: :completed)
      insert(:search_result, keyword: keyword)
      keyword_id = keyword.id

      conn =
        conn
        |> log_in_user(user)
        |> get(Routes.keyword_html_path(conn, :html, keyword.id))

      assert %Keyword{id: ^keyword_id} = conn.assigns[:keyword]
    end

    test "redirects to the keywords dashboad page if the keyword is not found", %{conn: conn} do
      user = insert(:user)

      conn =
        conn
        |> log_in_user(user)
        |> get(Routes.keyword_html_path(conn, :html, 100))

      assert redirected_to(conn) == "/keywords"
    end
  end
end
