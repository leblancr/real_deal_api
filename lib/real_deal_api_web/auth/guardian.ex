defmodule RealDealApiWeb.Auth.Guardian do
  @moduledoc false
  use Guardian, otp_app: :real_deal_api
  alias RealDealApi.Accounts

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

  # Accounts.get_account_by_email(email) returns an account
  def authenticate(email, password) do
    case Accounts.get_account_by_email(email) do
      nil -> {:error, :unauthorized}
      account ->
        case validate_password(password, account.hash_password) do
          true -> create_token(account) # returns {:ok, account, token}
          false -> {:error, :unauthorized}
        end
    end
  end

  defp validate_password(password, hash_password) do
    Bcrypt.verify_pass(password, hash_password)
  end

  # guardian encode and sign
  defp create_token(account) do
    {:ok, token, _claims} = encode_and_sign(account)
    {:ok, account, token}
  end

end
