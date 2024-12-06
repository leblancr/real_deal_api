defmodule RealDealApiWeb.AccountController do
  @moduledoc """
  Controller action functions.
  The AccountController handles requests related to user accounts.
  Functions that endpoints can hit.
  It provides actions for listing accounts, creating new accounts, and
  managing account-related functionalities within the RealDeal API.
  """
  require Logger
  use RealDealApiWeb, :controller

  alias RealDealApiWeb.{Auth.Guardian, Auth.ErrorResponse}
  alias RealDealApi.{Accounts, Accounts.Account, Users, Users.User}

  plug :is_authorized_account when action in [:update, :delete]

  action_fallback RealDealApiWeb.FallbackController

  defp authorize_account(conn, email, hash_password) do
    case Guardian.authenticate(email, hash_password) do
      {:ok, account, token} ->
        # Print the JWT (token)
        IO.inspect(token, label: "AccountController JWT Token")

        conn
        |> IO.inspect(label: "AccountController Conn1")
        |> Plug.Conn.put_session(:account_id, account.id) # we made
        |> IO.inspect(label: "AccountController Conn2")
        |> put_status(:ok)
        |> json(%{account: account, token: token})
      {:error, :unauthorized} -> raise ErrorResponse.Unauthorized, message: "Email or Password incorrect."
    end
  end

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

  authorize with passed in password not from created account which is hashed.
  """
  def create(conn, %{"account" => account_params}) do
    with {:ok, %Account{} = account} <- Accounts.create_account(account_params),
         {:ok, %User{} = _user} <- Users.create_user(account, account_params) do
      authorize_account(conn, account.email, account_params["hash_password"])
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
  Get id from conn params, get account for that id from database
    Compare the id from conn.assigns.account.id (signed in id) to the one in database
  """
  defp is_authorized_account(conn, _opts) do
    %{params: %{"account" => params}} = conn
    account = Accounts.get_account!(params["id"]) # get account from database for that id
    if conn.assigns.account.id == account.id do
      conn
    else
      raise ErrorResponse.Forbidden
    end
  end

  @doc """
  Gets a new token.
  """
  def refresh_session(conn, %{}) do
    token = Guardian.Plug.current_token(conn)
    {:ok, account, new_token} = Guardian.authenticate(token)
    conn
    |> Plug.Conn.put_session(:account_id, account.id)
    |> put_status(:ok)
    |> json(%{account: account, token: new_token})
  end

  @doc """
    get "/accounts/by_id/:id", AccountController, :show

    Get the id from the user account obtained from sign_in/authenticate
  """
  def show(conn, %{"id" => id}) do
    # Log the Authorization header (Bearer token)
    token = get_req_header(conn, "authorization") |> List.first()
    Logger.debug("Authorization header: #{inspect(token)}")

    account = Accounts.get_account!(id)
    IO.inspect(conn, label: "show Conn")  # Works because it's executed at runtime
    json(conn, account)
  end

  @doc """
    `post "/accounts/sign_in", AccountController, :sign_in`

      returns account and token in response
  """
  def sign_in(conn, %{"email" => email, "hash_password" => hash_password}) do
    authorize_account(conn, email, hash_password)
  end

  def sign_out(conn, %{}) do
    account = conn.assigns[:account]
    token = Guardian.Plug.current_token(conn)
    Guardian.revoke(token)
    token = nil
    conn
    |> Plug.Conn.clear_session()
    |> put_status(:ok)
    |> json(%{account: account, token: token})
  end

  @doc """
  post "/accounts/update", AccountController, :update`

  Get account from database by id. Update account with new account params.
  Write account back to database with new info.
  """
  def update(conn, %{"account" => account_params}) do
    account = Accounts.get_account!(account_params["id"])

    with {:ok, %Account{} = account} <- Accounts.update_account(account, account_params) do
      json(conn, account)
    end
  end
end
