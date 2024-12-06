defmodule RealDealApiWeb.Auth.Guardian do
  @moduledoc """
  Implementation file for Guardian
  """
  use Guardian, otp_app: :real_deal_api
  alias RealDealApi.Accounts

  @doc """
  Accounts.get_account_by_email(email) returns an account
    Checks the passed in password against the one in the account:
    validate_password(password, account.hash_password)
  """
  def authenticate(email, password) do
    IO.puts("guardian.ex authenticating email: #{email}, password: #{password}")
    case Accounts.get_account_by_email(email) do
      nil -> {:error, :unauthorized}
      account ->
        IO.puts("Guardian account: #{inspect(account)}") # account is a struct: %RealDealApi.Accounts.Account
        case validate_password(password, account.hash_password) do
          true -> create_token(account) # returns {:ok, account, token}
          false -> {:error, :unauthorized}
        end
    end
  end

  # guardian encode and sign
  defp create_token(account) do
    {:ok, token, _claims} = encode_and_sign(account)
    {:ok, account, token}
  end

  @doc """
  %{id: id} means you're matching a map (not struct because no module prefix)
  that has a key :id, and you want to bind the value associated with that key to the variable id
  """
  def subject_for_token(%{id: id}, _claims) do
    sub = to_string(id)
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, :no_id_provided}
  end

  @doc """
  %{"sub" => id} map that has a key "sub" and binding its value to the variable id
  """
  def resource_from_claims(%{"sub" => id}) do
    case Accounts.get_account!(id) do
      nil -> {:error, :not_found}
      resource -> {:ok, resource}
    end
  end

  def resource_from_claims(_claims) do
    {:error, :no_id_provided}
  end

  defp validate_password(password, hash_password) do
    Bcrypt.verify_pass(password, hash_password) # returns true or false
  end

  def after_encode_and_sign(resource, claims, token, _options) do
    with {:ok, _} <- Guardian.DB.after_encode_and_sign(resource, claims["typ"], claims, token) do
      {:ok, token}
    end
  end

  def on_verify(claims, token, _options) do
    with {:ok, _} <- Guardian.DB.on_verify(claims, token) do
      {:ok, claims}
    end
  end

  def on_refresh({old_token, old_claims}, {new_token, new_claims}, _options) do
    with {:ok, _, _} <- Guardian.DB.on_refresh({old_token, old_claims}, {new_token, new_claims}) do
      {:ok, {old_token, old_claims}, {new_token, new_claims}}
    end
  end

  def on_revoke(claims, token, _options) do
    with {:ok, _} <- Guardian.DB.on_revoke(claims, token) do
      {:ok, claims}
    end
  end
end

