#!/bin/sh

bin/elixir_google_scraper eval "ElixirGoogleScraper.ReleaseTasks.migrate()"

bin/elixir_google_scraper start
