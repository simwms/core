defmodule Core.SessionController do
  use Core.Web, :controller

  alias Core.Session

  plug :scrub_params, "session" when action in [:create, :update]

  def create(conn, %{"session" => session_params}) do
    session = conn |> Session.login!(session_params)
    if session.logged_in? do
      session.conn
      |> render("show.json", session: session)
    else
      session.conn
      |> put_status(:unprocessable_entity)
      |> render(Core.ChangesetView, "error.json", session: session)
    end
  end

  def delete(conn, %{"id" => id}) do
    session = conn |> Session.logout!(id)
    unless session.logged_in? do
      session.conn
      |> render("show.json", session: session)
    else
      session.conn
      |> put_status(:unprocessable_entity)
      |> render(Core.ChangesetView, "error.json", session: session)
    end
  end
end