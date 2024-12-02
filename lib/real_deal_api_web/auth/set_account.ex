defmodule RealDealApiWeb.Auth.SetAccount do
  @moduledoc """
  By storing the account in conn.assigns, you make it easily accessible to your controllers, views,
  or any subsequent plugs without needing to manually fetch it again from the database or session.
  """
  import Plug.Conn
  alias RealDealApiWeb.Auth.ErrorResponse
  alias RealDealApi.Accounts

  def init(_options) do
    # No need for initialization in this case
    []
  end

  # take conn, return new one with account added
  def call(conn, _options) do
    IO.inspect(conn, label: "SetAccount1 Conn")  # Works because it's executed at runtime

    if conn.assigns[:account] do
      # If the account is already assigned, we just return the conn
      conn
    else
      # Fetch account_id from session
      account_id = get_session(conn, :account_id)

      if is_nil(account_id) do
        raise ErrorResponse.Unauthorized
      end

      # Try fetching the account from the database
      account = Accounts.get_account!(account_id)

      # If no account is found, raise Unauthorized error
      if is_nil(account) do
        raise ErrorResponse.Unauthorized
      end

      # Assign the account to the conn
      IO.inspect(conn, label: "SetAccount2 Conn")  # Log after account is fetched

      conn
      |> assign(:account, account)
      |> IO.inspect(label: "SetAccount3 Conn")  # Log after assignment    end
    end
  end
end
