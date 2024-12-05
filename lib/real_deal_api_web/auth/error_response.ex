defmodule RealDealApiWeb.Auth.ErrorResponse.Unauthorized do
  @moduledoc """
  The defexception macro does not define the module; rather, it modifies the module to make it an exception.
  Specifically, it automatically adds fields like message and plug_status (or any others you define),
  and it also adds behavior so the module can be raised as an exception.
  """
  defexception [message: "unauthorized", plug_status: 401]
end

defmodule RealDealApiWeb.Auth.ErrorResponse.Forbidden do
  defexception [message: "You do not have access to this resource.", plug_status: 403]
end
