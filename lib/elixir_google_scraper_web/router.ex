defmodule ElixirGoogleScraperWeb.Router do
  use ElixirGoogleScraperWeb, :router
  use PhoenixOauth2Provider.Router, otp_app: :elixir_google_scraper

  import ElixirGoogleScraperWeb.UserAuth

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:fetch_current_user)
  end

  # coveralls-ignore-start
  pipeline :api do
    plug(:accepts, ["json"])

    scope "/api/v1", ElixirGoogleScraperWeb, as: :api_v1 do
      post("/oauth/token", Api.V1.TokenController, :create)
    end
  end

  # API routes
  pipeline :protected do
    # Require user authentication
  end

  scope "/" do
    pipe_through([:browser, :protected])

    oauth_routes()
  end

  # coveralls-ignore-stop

  scope "/", ElixirGoogleScraperWeb do
    pipe_through(:browser)

    get("/", PageController, :index)
  end

  # Other scopes may use custom stacks.
  # scope "/api", ElixirGoogleScraperWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through(:browser)
      # coveralls-ignore-start
      live_dashboard("/dashboard", metrics: ElixirGoogleScraperWeb.Telemetry)
      # coveralls-ignore-stop
    end
  end

  ## Authentication routes

  scope "/", ElixirGoogleScraperWeb do
    pipe_through([:browser, :redirect_if_user_is_authenticated])

    get("/users/register", UserRegistrationController, :new)
    post("/users/register", UserRegistrationController, :create)
    get("/users/log_in", UserSessionController, :new)
    post("/users/log_in", UserSessionController, :create)
    get("/users/reset_password", UserResetPasswordController, :new)
    post("/users/reset_password", UserResetPasswordController, :create)
    get("/users/reset_password/:token", UserResetPasswordController, :edit)
    put("/users/reset_password/:token", UserResetPasswordController, :update)
  end

  scope "/", ElixirGoogleScraperWeb do
    pipe_through([:browser, :require_authenticated_user])

    get("/users/settings", UserSettingsController, :edit)
    put("/users/settings", UserSettingsController, :update)

    resources "/keywords", KeywordController, only: [:index, :create, :show] do
      get("/html_response", KeywordController, :html, as: :html)
    end
  end

  scope "/", ElixirGoogleScraperWeb do
    pipe_through([:browser])

    delete("/users/log_out", UserSessionController, :delete)
    get("/users/confirm", UserConfirmationController, :new)
    post("/users/confirm", UserConfirmationController, :create)
    get("/users/confirm/:token", UserConfirmationController, :confirm)
  end
end
