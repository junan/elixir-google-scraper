defmodule ElixirGoogleScraper.Scraper do
  @moduledoc """
  The Scraper context.
  """

  import Ecto.Query, warn: false

  alias ElixirGoogleScraper.Accounts.User
  alias ElixirGoogleScraper.Repo
  alias ElixirGoogleScraper.Scraper.{CSVKeyword, Keyword}

  def paginated_user_keywords(user, params \\ %{}) do
    user
    |> user_keywords_query
    |> filtered_keywords_query(params["name"])
    |> Repo.paginate(params)
  end

  def save_keywords(file, %User{} = user) do
    case CSVKeyword.validate(file) do
      {:ok, keyword_list} ->
        Enum.each(keyword_list, fn keyword ->
          create_keyword(%{
            name: List.first(keyword),
            user_id: user.id
          })
        end)

        :ok

      {:error, :file_is_empty} ->
        {:error, :file_is_empty}

      {:error, :keyword_list_exceeded} ->
        {:error, :keyword_list_exceeded}
    end
  end

  defp create_keyword(attrs) do
    %Keyword{}
    |> Keyword.changeset(attrs)
    |> Repo.insert()
  end

  defp user_keywords_query(user) do
    where(Keyword, [k], k.user_id == ^user.id)
  end

  defp filtered_keywords_query(query, nil) do
    query
  end

  defp filtered_keywords_query(query, query_string) do
    where(query, [k], ilike(k.name, ^"#{query_string}%"))
  end
end
