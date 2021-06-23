defmodule ElixirGoogleScraper.Scraper.KeywordScraper do
  def scraping(keyword) do
    make_request(keyword)
  end

  def google_search_url, do: "https://www.google.com/search"

  defp make_request(keyword) do
    keyword
    |> build_url
    |> HTTPoison.get!()
    |> parse_response
  end

  defp build_url(keyword) do
    "#{google_search_url}?q=#{keyword}"
  end

  def parse_response(response) do
    {:ok, document} = Floki.parse_document(response.body)

    IO.inspect(document, label: "Document")

    document
  end
end
