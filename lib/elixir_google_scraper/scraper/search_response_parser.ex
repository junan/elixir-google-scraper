defmodule ElixirGoogleScraper.Scraper.SearchResponseParser do
  alias ElixirGoogleScraper.Scraper.SearchResult

  @selector_mapping %{
    top_ads_count: "#tads .uEierd",
    top_ads_urls: "#tads .Krnil",
    total_ads_count: ".Krnil",
    result_urls: ".yuRUbf > a",
    # result_urls: ".ZINbbc.xpd.O9g5cc.uUPGi .BNeawe.UPmit.AP7Wnd",
    # total_result: ".ZINbbc.xpd.O9g5cc.uUPGi .BNeawe.UPmit.AP7Wnd",
    total_result: ".yuRUbf",
    total_links_count: "a[href]"
  }

  def parse(response) do
    {_, document} = Floki.parse_document(response.body)

    File.write!("html.html", response.body)

    %SearchResult{
      top_ads_count: top_ads_count(document),
      top_ads_urls: top_ads_urls(document),
      html: response.body,
      result_count: result_count(document),
      result_urls: result_urls(document),
      total_links_count: total_links_count(document)
    }
  end

  defp total_links_count(document) do
    document
    |> Floki.find(@selector_mapping.total_links_count)
    |> Enum.count()
  end

  defp result_count(document) do
    document
    |> Floki.find(@selector_mapping.total_result)
    |> Enum.count()
  end

  defp result_urls(document) do
    document
    |> Floki.find(@selector_mapping.result_urls)
    |> Floki.attribute("href")
  end

  def top_ads_count(document) do
    document
    |> Floki.find(@selector_mapping.top_ads_count)
    |> Enum.count()
  end

  defp top_ads_urls(document) do
    document
    |> Floki.find(@selector_mapping.top_ads_urls)
    |> Floki.attribute("href")
  end
end
