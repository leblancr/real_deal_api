defmodule RealDealApiWeb.AccountController do
  @moduledoc """
  Controller action functions.
  The AccountController handles requests related to user accounts.
  Functions that endpoints can hit.
  It provides actions for listing accounts, creating new accounts, and
  managing account-related functionalities within the RealDeal API.
  """

  use RealDealApiWeb, :controller

  alias RealDealApiWeb.{Auth.Guardian, Auth.ErrorResponse}
  alias RealDealApi.{Accounts, Accounts.Account, Users, Users.User}

  action_fallback RealDealApiWeb.FallbackController

  @doc """
  Called when endpoint hit in router.ex:
  When this endpoint hit, call this Module, :function.
  `post "/accounts/create", AccountController, :create`

  Takes conn and an account struct that gets called account_params
    account_params = {email: "client5@proton.me", hash_password: "our_password5"}

  `{:ok, %Account{} = account}` <- Accounts.create_account(account_params) means:
  `Accounts.create_account/1` returns a `{:ok, %Account{}}`, then
  %Account{} struct that is returned is assigned to = account
  multiple functions can be called in with, executed in order
  """
  def create(conn, %{"account" => account_params}) do
    with {:ok, %Account{} = account} <- Accounts.create_account(account_params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(account), # generate a JWT
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

  @doc """
    get "/accounts/by_id/:id", AccountController, :show

    Get the id from the user account obtained from sign_in/authenticate
  """
  def show(conn, %{"id" => id}) do
    # account = Accounts.get_account!(id)
    IO.inspect(conn, label: "show Conn")  # Works because it's executed at runtime
    json(conn, conn.assigns.account)
  end

  @doc """
    `post "/accounts/sign_in", AccountController, :sign_in`

      returns account and token in response
  """
  def sign_in(conn, %{"email" => email, "hash_password" => hash_password}) do
    case Guardian.authenticate(email, hash_password) do
      {:ok, account, token} ->
        # Print the JWT (token)
        IO.inspect(token, label: "AccountController JWT Token")

        conn
        IO.inspect(conn, label: "AccountController Conn")
        |> Plug.Conn.put_session(:account_id, account.id)
        |> put_status(:ok)
        |> json(%{account: account, token: token})
      {:error, :unauthorized} -> raise ErrorResponse.Unauthorized, message: "Email or Password incorrect."
    end
  end

  def update(conn, %{"id" => id, "account" => account_params}) do
    account = Accounts.get_account!(id)

    with {:ok, %Account{} = account} <- Accounts.update_account(account, account_params) do
      json(conn, account)
    end
  end
end
