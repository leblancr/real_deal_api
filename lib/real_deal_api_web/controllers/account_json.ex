defmodule RealDealApiWeb.AccountJSON do
  @moduledoc """
  account_view.ex is now account_json.ex
  """
  alias RealDealApi.Accounts.Account
  alias RealDealApiWeb.UserJSON

  @doc """
  Renders an account.
  """
  def account(%{account: account}) do
    IO.inspect(account.user, label: "*** ACCOUNT account.user:")
    %{
      id: account.id,
      email: account.email,
      hash_password: account.hash_password
    }
  end

  @doc """
  Renders an account with user.
  """
  def full_account(%{account: account}) do
    IO.inspect(account.user, label: "*** FULL account.user:")
    %{
      id: account.id,
      email: account.email,
      user: account.user
    }
  end

  @doc """
  Renders a list of accounts.
  """
  def index(%{accounts: accounts}) do
    %{data: for(account <- accounts, do: data(account))}
  end

  @doc """
  Renders a single account.
  """
  def show(%{account: account}) do
    # IO.inspect(account.user, label: "*** SHOW account.user:")
    %{data: data(account)} # wrapped in a :data atom key
  end

  defp data(%Account{} = account) do
    # IO.inspect(account.user, label: "*** DATA account.user:")
    %{
      id: account.id,
      email: account.email,
      hash_password: account.hash_password,
      user: account.user  # Include associated user data
    }
  end
end
