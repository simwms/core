defmodule Core.PageController do
  use Core.Web, :controller
  def index(conn, _params) do
    conn
    |> render("index.html")
  end
end