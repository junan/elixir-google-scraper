defmodule ElixirGoogleScraper.Scraper.KeywordScraper do
  alias ElixirGoogleScraper.Scraper.SearchResponseParser

  def scrap(keyword) do
    response = make_request(keyword)
    SearchResponseParser.parse(response)
  end

  def google_search_url, do: "https://www.google.com/search"

  defp make_request(keyword) do
    keyword
    |> build_url
    |> HTTPoison.get!(headers)
  end

  def headers do
    user_agent =
      "Mozilla/5.0 (Macintosh; Intel Mac OS X 11_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.447"

    ["User-Agent": user_agent]
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
