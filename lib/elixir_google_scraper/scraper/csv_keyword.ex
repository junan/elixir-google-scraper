defmodule ElixirGoogleScraper.Scraper.CSVKeyword do
  alias NimbleCSV.RFC4180, as: CSV

  def validate(file) do
    keyword_list = parse(file)

    cond do
      length(keyword_list) <= 0 -> {:error, :file_is_empty}
      length(keyword_list) > 1000 -> {:error, :keyword_list_exceed}
      true -> {:ok, keyword_list}
    end
  end

  def parse(%Plug.Upload{content_type: "text/csv"} = file) do
    file.path
    |> File.stream!()
    |> CSV.parse_stream(skip_headers: false)
    |> Enum.to_list()
  end

  def parse(_), do: {:error, :file_is_invalid}
end
