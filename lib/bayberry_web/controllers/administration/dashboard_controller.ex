defmodule BayberryWeb.Administration.DashboardController do
  use BayberryWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
