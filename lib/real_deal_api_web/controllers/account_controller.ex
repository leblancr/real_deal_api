defmodule RealDealApiWeb.AccountController do
  @moduledoc """
  The AccountController handles requests related to user accounts.
  Functions that endpoints can hit.
  It provides actions for listing accounts, creating new accounts, and
  managing account-related functionalities within the RealDeal API.
  """

  use RealDealApiWeb, :controller

  alias RealDealApiWeb.Auth.Guardian
  alias RealDealApi.{Accounts, Accounts.Account, Users, Users.User}

  action_fallback RealDealApiWeb.FallbackController

  @doc """
  {:ok, %Account{} = account} <- Accounts.create_account(account_params) means:
  Accounts.create_account() returns a {:ok, %Account{}}, then
  %Account{} struct that is returned is assigned to = account
  multiple functions can be called in with, executed in order
  """
  def create(conn, %{"account" => account_params}) do
    with {:ok, %Account{} = account} <- Accounts.create_account(account_params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(account),
         {:ok, %User{} = _user} <- Users.create_user(account, account_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/accounts/#{account}")
      |> json(%{account: account, token: token})
    end
  end

  def delete(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)

    with {:ok, %Account{}} <- Accounts.delete_account(account) do
      send_resp(conn, :no_content, "")
    end
  end

  def index(conn, _params) do
    accounts = Accounts.list_accounts()
    json(conn, accounts)
  end

  def show(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)
    json(conn, account)
  end

  def update(conn, %{"id" => id, "account" => account_params}) do
    account = Accounts.get_account!(id)

    with {:ok, %Account{} = account} <- Accounts.update_account(account, account_params) do
      json(conn, account)
    end
  end
end
