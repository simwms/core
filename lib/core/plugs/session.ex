defmodule Core.Plugs.Session do
  import Plug.Conn
  import Core.Session, only: [logged_in?: 1]
  import Phoenix.Controller, only: [render: 4]
  def init(options), do: options

  def call(conn, _opts) do
    if conn |> logged_in? do
      conn
    else
      conn
      |> put_status(:forbidden)
      |> render(Core.ErrorView, "forbidden.json", msg: "Not logged in")
      |> halt
    end
  end
end