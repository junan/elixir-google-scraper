defmodule ElixirGoogleScraperWeb.Api.V1.KeywordControllerTest do
  use ElixirGoogleScraperWeb.ConnCase, async: true

  describe "GET index/2" do
    test "returns 200 status with list of keywords", %{conn: conn} do
      user = insert(:user)
      insert_list(2, :keyword, user: user)

      conn =
        conn
        |> authenticated_api_conn(user)
        |> get(Routes.api_v1_keyword_path(conn, :index))

      assert %{
               "data" => [
                 %{
                   "attributes" => %{
                     "name" => _,
                     "inserted_at" => _,
                     "status" => _
                   },
                   "id" => _,
                   "relationships" => %{},
                   "type" => "keyword"
                 },
                 %{
                   "attributes" => %{
                     "name" => _,
                     "inserted_at" => _,
                     "status" => _
                   },
                   "id" => _,
                   "relationships" => %{},
                   "type" => "keyword"
                 }
               ],
               "included" => [],
               "meta" => %{"page" => _, "page_size" => _, "pages" => _, "records" => _}
             } = json_response(conn, 200)
    end

    test "returns only matched keywords when given search param", %{conn: conn} do
      user = insert(:user)
      insert(:keyword, name: "Bangkok", user: user)
      insert(:keyword, name: "Phuket", user: user)

      conn =
        conn
        |> authenticated_api_conn(user)
        |> get(Routes.api_v1_keyword_path(conn, :index), %{name: "Bangkok"})

      assert %{
               "data" => [
                 %{
                   "attributes" => %{
                     "name" => "Bangkok",
                     "inserted_at" => _,
                     "status" => _
                   },
                   "id" => _,
                   "relationships" => %{},
                   "type" => "keyword"
                 }
               ],
               "included" => [],
               "meta" => %{"page" => _, "page_size" => _, "pages" => _, "records" => _}
             } = json_response(conn, 200)
    end
  end

  describe "POST create/2" do
    test "returns 201 status with empty response body when the token is valid", %{conn: conn} do
      user = insert(:user)
      file = %Plug.Upload{content_type: "text/csv", path: "test/fixture/keywords.csv"}

      conn =
        conn
        |> authenticated_api_conn(user)
        |> post(Routes.api_v1_keyword_path(conn, :create), %{file: file})

      assert conn.status == 201
      assert conn.resp_body == ""
    end

    test "returns 401 status with an error when the token is invalid", %{conn: conn} do
      file = %Plug.Upload{content_type: "text/csv", path: "test/fixture/keywords.csv"}

      conn =
        conn
        |> put_req_header("authorization", "Bearer " <> "invalid-token")
        |> post(Routes.api_v1_keyword_path(conn, :create), %{file: file})

      assert json_response(conn, 401) == %{
               "errors" => [%{"detail" => "Authentication failed"}]
             }
    end

    test "returns 422 status with an error when keywords are empty", %{conn: conn} do
      user = insert(:user)
      file = %Plug.Upload{content_type: "text/csv", path: "test/fixture/empty_keywords.csv"}

      conn =
        conn
        |> authenticated_api_conn(user)
        |> post(Routes.api_v1_keyword_path(conn, :create), %{file: file})

      assert json_response(conn, 422) == %{
               "errors" => [%{"detail" => "File can't be empty"}]
             }
    end

    test "returns 422 status with an error when keywords are more than 1000", %{conn: conn} do
      user = insert(:user)
      file = %Plug.Upload{content_type: "text/csv", path: "test/fixture/large_keywords.csv"}

      conn =
        conn
        |> authenticated_api_conn(user)
        |> post(Routes.api_v1_keyword_path(conn, :create), %{file: file})

      assert json_response(conn, 422) == %{
               "errors" => [%{"detail" => "CSV Keywords count can't be more than 1000"}]
             }
    end
  end

  describe "GET show/2" do
    test "returns 200 status with details keyword search result when the given keyword does belong to the current user",
         %{conn: conn} do
      user = insert(:user)
      keyword = insert(:keyword, user: user)
      insert(:search_result, keyword: keyword)

      conn =
        conn
        |> authenticated_api_conn(user)
        |> get(Routes.api_v1_keyword_path(conn, :show, keyword.id))

      assert %{
               "data" => %{
                 "attributes" => %{
                   "top_ads_count" => _,
                   "top_ads_urls" => _,
                   "total_ads_count" => _,
                   "result_count" => _,
                   "result_urls" => _,
                   "total_links_count" => _,
                   "html" => _,
                   "inserted_at" => _
                 },
                 "id" => _,
                 "relationships" => %{},
                 "type" => "keyword_search_result"
               },
               "included" => []
             } = json_response(conn, 200)
    end

    test "returns 404 status with an error message when the given keyword does not belong to the current user",
         %{conn: conn} do
      user = insert(:user)
      user2 = insert(:user)
      keyword = insert(:keyword, user: user2)
      insert(:search_result, keyword: keyword)

      conn =
        conn
        |> authenticated_api_conn(user)
        |> get(Routes.api_v1_keyword_path(conn, :show, keyword.id))

      assert %{
               "errors" => [%{"detail" => "Keyword not found"}]
             } == json_response(conn, 404)
    end

    test "returns 404 status with an error message when the given keyword does not exist",
         %{conn: conn} do
      user = insert(:user)

      conn =
        conn
        |> authenticated_api_conn(user)
        |> get(Routes.api_v1_keyword_path(conn, :show, 1000))

      assert %{
               "errors" => [%{"detail" => "Keyword not found"}]
             } == json_response(conn, 404)
    end
  end
end
