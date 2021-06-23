defmodule ElixirGoogleScraper.Scraper do
  @moduledoc """
  The Scraper context.
  """

  import Ecto.Query, warn: false

  alias ElixirGoogleScraper.Accounts.User
  alias ElixirGoogleScraper.Repo
  alias ElixirGoogleScraper.Scraper.{CSVKeyword, Keyword}
  alias ElixirGoogleScraper.Scraper.Worker.ScrapingWorker

  def paginated_user_keywords(user, params \\ %{}) do
    user
    |> user_keywords_query
    |> Repo.paginate(params)
  end

  def save_keywords(file, %User{} = user) do
    case CSVKeyword.validate(file) do
      {:ok, keyword_list} ->
        keywords =
          Enum.map(keyword_list, fn keyword ->
            {_, keyword} =
              create_keyword(%{
                name: List.first(keyword),
                user_id: user.id
              })

            keyword
          end)

        enqueue_keywords(keywords)

        :ok

      {:error, :file_is_empty} ->
        {:error, :file_is_empty}

      {:error, :keyword_list_exceeded} ->
        {:error, :keyword_list_exceeded}
    end
  end

  def enqueue_keywords(keywords) do
    keywords
    |> Enum.with_index()
    |> Enum.each(fn {keyword, index} ->
      IO.inspect(index, label: "Index")

      %{keyword_id: keyword.id}
      |> ScrapingWorker.new(schedule_in: index + 2)
      |> Oban.insert()
    end)
  end

  defp create_keyword(attrs) do
    %Keyword{}
    |> Keyword.changeset(attrs)
    |> Repo.insert()
  end

  defp user_keywords_query(user) do
    where(Keyword, [k], k.user_id == ^user.id)
  end
end
