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
    google_search_url
    |> URI.parse()
    |> Map.put(:query, URI.encode_query(q: keyword, hl: "en", lr: "lang_on"))
    |> URI.to_string()
  end

  def parse_response(response) do
    {_, document} = Floki.parse_document(response.body)

    document
  end
end
