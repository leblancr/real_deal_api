defmodule RealDealApiWeb.DefaultController do
  @moduledoc false

  use RealDealApiWeb, :controller

  def index(conn, _params) do
    text conn, "Live - #{Mix.env()}"
  end
end
