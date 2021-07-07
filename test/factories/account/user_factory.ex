defmodule ElixirGoogleScraper.Account.UserFactory do
  defmacro __using__(_opts) do
    quote do
      def user_factory(attrs) do
        password = attrs[:password] || "secret-password"
        email = attrs[:email] || sequence(:email, fn n -> "email-#{n}@example.com" end)

        %ElixirGoogleScraper.Account.Schemas.User{
          email: email,
          hashed_password: Bcrypt.hash_pwd_salt(password)
        }
      end
    end
  end
end
