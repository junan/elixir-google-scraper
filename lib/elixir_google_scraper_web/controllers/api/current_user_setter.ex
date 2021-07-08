defmodule ElixirGoogleScraperWeb.Api.CurrentUserSetter do
  import Plug.Conn

  def set_current_user(conn, _) do
    token = ExOauth2Provider.Plug.current_access_token(conn)
    conn = assign(conn, :current_user, token.resource_owner)
    conn
  end
end
