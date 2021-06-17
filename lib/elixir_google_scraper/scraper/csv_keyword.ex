defmodule ElixirGoogleScraper.Scraper.CSVKeyword do
  alias NimbleCSV.RFC4180, as: CSV

  def validate(file) do
    keyword_list = parse(file)

    case length(keyword_list) do
      length when length <= 0 -> {:error, :file_is_empty}
      length when length > 1000 -> {:error, :keyword_list_exceeded}
      _ -> {:ok, keyword_list}
    end
  end

  defp parse(%Plug.Upload{content_type: "text/csv"} = file) do
    file.path
    |> File.stream!()
    |> CSV.parse_stream(skip_headers: false)
    |> Enum.to_list()
  end
end
