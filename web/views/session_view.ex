defmodule Core.SessionView do
  use Core.Web, :view
  import Fox.DictExt, only: [reject_blank_keys: 1]

  def render("ok.json", _), do: %{}

  def render("show.json", %{session: session}) do
    %{session: render_one(session, __MODULE__, "session.json")}
  end

  def render("session.json", %{session: session}) do
    session |> ember_attributes |> reject_blank_keys
  end

  def ember_attributes(session) do
    %{id: session.id,
      remember_token: session.remember_token,
      user: render_user(session)}
  end

  def render_user(%{user: nil}), do: nil
  def render_user(%{user: user}) do
    user |> render_one(Core.UserView, "user.json")
  end
end