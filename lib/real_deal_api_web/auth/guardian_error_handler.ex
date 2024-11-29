defmodule RealDealApiWeb.Auth.GuardianErrorHandler do
  @moduledoc """
  This is used in the pipeline.ex
  """
  import Plug.Conn

  # you must use this exact name for Guardian to recognize and call it when an authentication error occurs.
  def auth_error(conn, {type, _reason}, _opts) do
    body = Jason.encode!(%{error: to_string(type)}) # takes a map
    conn
    |> put_resp_content_type("application/json") # these two functions from Plug.Conn
    |> send_resp(401, body)
  end
end


