defmodule Core.SessionView do
  use Core.Web, :view
  import Fox.DictExt, only: [reject_blank_keys: 1]

  def render("show.json", %{session: session}) do
    %{session: render_one(session, "session.json")}
  end

  def render("session.json", %{session: session}) do
    session |> ember_attributes |> reject_blank_keys
  end

  def ember_attributes(session) do
    %{id: session.id,
      remember_token: session.user.remember_token,
      user: render_user(session)}
  end

  def render_user(%{user: user}) do
    user |> render_one("user.json")
  end
end