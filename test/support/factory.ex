defmodule ElixirGoogleScraper.Factory do
  use ExMachina.Ecto, repo: ElixirGoogleScraper.Repo

  use ElixirGoogleScraper.Account.UserFactory
  use ElixirGoogleScraper.Scraper.KeywordFactory
  use ElixirGoogleScraper.Scraper.SearchResultFactory
end
