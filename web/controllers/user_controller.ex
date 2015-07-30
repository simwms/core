defmodule Core.UserController do
  use Core.Web, :controller

  alias Core.User

  plug :scrub_params, "user" when action in [:create, :update]


  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)
    if changeset.valid? do
      user = Repo.insert!(changeset)
      render(conn, "show.json", user: user)
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render(Core.ChangesetView, "error.json", changeset: changeset)
    end
  end

  

end
