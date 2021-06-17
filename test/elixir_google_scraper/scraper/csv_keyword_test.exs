defmodule ElixirGoogleScraper.Scraper.CSVKeywordTest do
  use ElixirGoogleScraper.DataCase

  alias ElixirGoogleScraper.Scraper.CSVKeyword

  describe "validate/2" do
    test "returns ok when keyword file is valid" do
      file = %Plug.Upload{content_type: "text/csv", path: "test/fixture/keywords.csv"}

      assert {:ok, _} = CSVKeyword.validate(file)
    end

    test "returns an error when keyword file is INVALID" do
      file = %Plug.Upload{content_type: "text/csv", path: "test/fixture/empty_keywords.csv"}

      assert {:error, :file_is_empty} = CSVKeyword.validate(file)
    end
  end
end
