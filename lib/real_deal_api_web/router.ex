defmodule RealDealApiWeb.Router do
  use RealDealApiWeb, :router
  use Plug.ErrorHandler

  # Handle NoRouterError exception specifically
  defp handle_errors(conn, %{reason: %{__exception__: true, module: Phoenix.Router.NoRouterError}}) do
    # Return a custom message for NoRouterError (no route found)
    conn
    |> json(%{errors: "No route found"})
    |> halt()
  end
  defp handle_errors(conn, %{reason: %{message: message}}) do
    conn |> json(%{errors: message}) |> halt()
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", RealDealApiWeb do
    pipe_through :api
    get "/", DefaultController, :index
    post "/accounts/create", AccountController, :create
    post "/accounts/sign_in", AccountController, :sign_in
  end
end
