defmodule RealDealApiWeb.Auth.Pipeline do
  @moduledoc """
    Called from router.ex
  """

  # these lines are one use command with three options
  # use is a macro, inserts code at compile time
  use Guardian.Plug.Pipeline,
      otp_app: :real_deal_api, # use adds code at compile time
      module: RealDealApiWeb.Auth.Guardian, # key/value pairs used for config, word with colon
      error_handler: RealDealApiWeb.Auth.GuardianErrorHandler # auth_error()

  # Each plug looks for a jwt
  # plug is a macro
  # the plug macro expects an atom (such as :inspect_conn)

  # Adding a custom plug to inspect conn during runtime
  plug :inspect_conn

  plug Guardian.Plug.VerifySession #  checks for a session-based token
  plug Guardian.Plug.VerifyHeader # checks for a token in the request header
  plug Guardian.Plug.EnsureAuthenticated # ensure token found in either of previous two
  plug Guardian.Plug.LoadResource # user

  defp inspect_conn(conn, _opts) do
    # IO.inspect(conn, label: ":inspect_conn Conn")  # Works because it's executed at runtime
    conn  # Don't forget to return the conn to continue the pipeline
  end

  # If you need to raise Unauthorized explicitly
  defp handle_unauthorized(conn) do
    raise RealDealApiWeb.Auth.ErrorResponse.Unauthorized
  end
end
