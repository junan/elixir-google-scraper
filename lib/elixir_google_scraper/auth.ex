defmodule Auth do
  alias ElixirGoogleScraper.Repo
  alias ElixirGoogleScraper.Account.Schemas.User

  def authenticate(email, password, _) do
    User
    |> Repo.get_by(email: email)
    |> verify_password(password)
  end

  defp verify_password(user, password) do
    if User.valid_password?(user, password) do
      {:ok, user}
    else
      {:error, :invalid_password}
    end
  end
end
