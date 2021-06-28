defmodule ElixirGoogleScraper.Scraper.Keywords do
  use Ecto.Schema

  alias ElixirGoogleScraper.Repo
  alias ElixirGoogleScraper.Scraper.Schemas.Keyword

  def mark_as_completed(keyword) do
    keyword
    |> Keyword.complete_changeset()
    |> Repo.update!()
  end
end
