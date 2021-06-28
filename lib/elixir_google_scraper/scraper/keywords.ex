defmodule ElixirGoogleScraper.Scraper.Keywords do
  use Ecto.Schema

  alias ElixirGoogleScraper.Scraper.Schemas.Keyword
  alias ElixirGoogleScraper.Repo

  def mark_as_completed(keyword) do
    keyword
    |> Keyword.changeset(%{status: :completed})
    |> Repo.update!()
  end
end
