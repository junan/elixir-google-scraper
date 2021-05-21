defmodule ElixirGoogleScraperWeb.FeatureCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.Feature

      import ElixirGoogleScraper.Factory

      alias ElixirGoogleScraperWeb.Router.Helpers, as: Routes
    end
  end
end
