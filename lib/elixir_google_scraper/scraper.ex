defmodule ElixirGoogleScraper.Scraper do
  @moduledoc """
  The Scraper context.
  """

  import Ecto.Query, warn: false
  alias ElixirGoogleScraper.Repo

  alias ElixirGoogleScraper.Scraper.Keyword
  alias ElixirGoogleScraper.Accounts.User
  alias ElixirGoogleScraper.Scraper.CSVKeyword

  @doc """
  Returns the list of keywords.

  ## Examples

      iex> list_keywords()
      [%Keyword{}, ...]

  """
  def list_keywords do
    Repo.all(Keyword)
  end

  @doc """
  Gets a single keyword.

  Raises `Ecto.NoResultsError` if the Keyword does not exist.

  ## Examples

      iex> get_keyword!(123)
      %Keyword{}

      iex> get_keyword!(456)
      ** (Ecto.NoResultsError)

  """
  def get_keyword!(id), do: Repo.get!(Keyword, id)

  @doc """
  Creates a keyword.

  ## Examples

      iex> create_keyword(%{field: value})
      {:ok, %Keyword{}}

      iex> create_keyword(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_keyword(attrs \\ %{}) do
    %Keyword{}
    |> Keyword.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a keyword.

  ## Examples

      iex> update_keyword(keyword, %{field: new_value})
      {:ok, %Keyword{}}

      iex> update_keyword(keyword, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_keyword(%Keyword{} = keyword, attrs) do
    keyword
    |> Keyword.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a keyword.

  ## Examples

      iex> delete_keyword(keyword)
      {:ok, %Keyword{}}

      iex> delete_keyword(keyword)
      {:error, %Ecto.Changeset{}}

  """
  def delete_keyword(%Keyword{} = keyword) do
    Repo.delete(keyword)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking keyword changes.

  ## Examples

      iex> change_keyword(keyword)
      %Ecto.Changeset{data: %Keyword{}}

  """
  def change_keyword(%Keyword{} = keyword, attrs \\ %{}) do
    Keyword.changeset(keyword, attrs)
  end

  def save_keywords(file, %User{} = user) do
    case CSVKeyword.validate(file) do
      {:ok, keyword_list} ->
        Enum.each(keyword_list, fn keyword ->
          create_keyword(%{
            name: List.first(keyword),
            user_id: user.id,
            status: 0
          })
        end)

        {:ok, :file_is_proccessed}

      {:error, :file_is_empty} ->
        {:error, :file_is_empty}

      {:error, :keyword_list_exceed} ->
        {:error, :keyword_list_exceed}
    end
  end
end
