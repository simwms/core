defmodule Core.UserView do
  use Core.Web, :view
  import Fox.DictExt, only: [reject_blank_keys: 1]

  def render("index.json", %{users: users}) do
    %{user: render_many(users, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{user: render_one(user, "user.json")}
  end

  def render("user.json", %{user: user}) do
    user |> ember_attributes |> reject_blank_keys
  end

  def ember_attributes(user) do
    %{id: user.id,
      email: user.email,
      username: user.username,
      inserted_at: user.inserted_at,
      updated_at: user.updated_at}
  end
end
