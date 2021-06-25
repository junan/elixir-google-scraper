defmodule ElixirGoogleScraperWeb.UploadKeywords.UploadKeywordsTest do
  use ElixirGoogleScraperWeb.FeatureCase

  import Wallaby.Query, only: [button: 1, file_field: 1]

  feature "uploads the CSV keywords successfully", %{session: session} do
    session
    |> login_with_user
    |> attach_file(file_field("file"), path: "test/fixture/keywords.csv")
    |> click(button("Upload"))
    |> assert_has(Query.text("Your CSV file has been uploaded successfully"))
  end
end
