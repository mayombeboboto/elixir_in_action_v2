defmodule User do
  @moduledoc """
  Documentation for `User`.
  """
  @spec extract_user(%{}) :: {:ok, %{}} | {:error, atom()}
  def extract_user(user) do
    with {:ok, login} <- extract_login(user),
         {:ok, email} <- extract_email(user),
         {:ok, password} <- extract_password(user) do
      {:ok, %{ login: login, email: email, password: password }}
    end
  end

  defp extract_login(%{ "login" => login }), do: {:ok, login}
  defp extract_login(_user), do: {:error, :login_missing}

  defp extract_email(%{ "email" => email }), do: {:ok, email}
  defp extract_email(_user), do: {:error, :email_missing}

  defp extract_password(%{ "password" => password }), do: {:ok, password}
  defp extract_password(_user), do: {:error, :password_missing}
end
