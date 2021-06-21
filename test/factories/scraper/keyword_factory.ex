defmodule ElixirGoogleScraper.Scraper.KeywordFactory do
  defmacro __using__(_opts) do
    quote do
      def keyword_factory do
        %ElixirGoogleScraper.Scraper.Keyword{
          name: "Buy domain",
          status: :pending,
          user: build(:user)
        }
      end
    end
  end
end
