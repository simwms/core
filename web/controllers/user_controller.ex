defmodule Core.UserController do
  use Core.Web, :controller

  alias Core.User

  plug :scrub_params, "user" when action in [:create, :update]


  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)
    case changeset |> Repo.insert do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render("show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Core.ChangesetView, "error.json", changeset: changeset)
    end
  end

  

end
