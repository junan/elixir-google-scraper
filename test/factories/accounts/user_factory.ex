defmodule ElixirGoogleScraper.Accounts.UserFactory do
  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %ElixirGoogleScraper.Accounts.User{
          email: sequence(:email, fn n -> "email-#{n}@example.com" end),
          hashed_password: Bcrypt.hash_pwd_salt("secret-password")
        }
      end
    end
  end
end
