defmodule Core.Session do
  import String, only: [downcase: 1]
  import Ecto.Query, only: [from: 2]
  alias __MODULE__
  alias Core.Repo
  alias Core.User
  defstruct id: nil, logged_in?: false, user: nil, errors: [], conn: nil, remember_token: nil

  def current_user(conn) do
    user_via_session(conn) || user_via_token(conn)
  end

  defp user_via_session(conn) do
    conn
    |> Plug.Conn.get_session(:current_user)
    |> find_user_by_id
  end

  defp user_via_token(conn) do
    conn
    |> Plug.Conn.get_req_header("remember_token")
    |> List.first
    |> find_user_by_token
  end

  def logged_in?(conn) do
    case current_user(conn) do
      nil -> false
      _ -> true
    end
  end

  defp remove_remember_me(params) do
    params
    |> Dict.pop("remember_me")
    |> elem(1)
  end

  def login!(conn, %{"remember_me" => remember}=params) do
    session = conn |> login!(remove_remember_me params)

    if remember and session.logged_in? do
      session |> remember_me!
    else
      session
    end
  end

  def login!(conn, %{"email" => email, "password" => password}) when not(is_nil(email) or is_nil(password)) do
    case email |> find_user_by_email |> authenticate(password) do
      {:ok, user} -> 
        conn = conn |> Plug.Conn.put_session(:current_user, user.id)
        %Session{
          id: user.id,
          remember_token: user.remember_token,
          logged_in?: true,
          user: user,
          conn: conn }
      {:no, _} ->
        %Session{
          conn: conn,
          errors: [email: "not in database"] }
      _ ->
        %Session{
          conn: conn,
          errors: [password: "wrong"] }
    end
  end

  def login!(conn, %{"username" => username, "password" => password}) when not(is_nil(username) or is_nil(password)) do
    case username |> find_user_by_username |> authenticate(password) do
      {:ok, user} -> 
        %Session{
          id: user.id,
          remember_token: user.remember_token,
          logged_in?: true,
          user: user,
          conn: conn |> Plug.Conn.put_session(:current_user, user.id) }
      {:no, _} ->
        %Session{
          conn: conn,
          errors: [email: "not in database"] }
      _ ->
        %Session{
          conn: conn,
          errors: [password: "wrong"] }
    end
  end

  def login!(conn, %{"remember_token" => token}) when not is_nil(token) do
    if user = token |> find_user_by_token do
      %Session{
        id: user.id,
        remember_token: user.remember_token,
        logged_in?: true,
        user: user,
        conn: conn |> Plug.Conn.put_session(:current_user, user.id) }
    else
      %Session{
        conn: conn,
        errors: [remember_token: "no such thing"] }
    end
  end

  def login!(conn, _) do
    %Session{
      conn: conn,
      errors: [
        email: "cannot be nil", 
        password: "cannot be nil", 
        username: "cannot be nil", 
        remember_token: "cannot be nil"
      ]
    }
  end

  def update_remember_me_token!(user) do
    remember_params = %{"remember_token" => random_characters}
    user
    |> User.changeset(remember_params)
    |> Repo.update!
  end

  def remember_me!(%{user: user}=session) do
    user = update_remember_me_token!(user)
    %{session | user: user, remember_token: user.remember_token }
  end

  def forget_me!(nil), do: nil
  def forget_me!(user) do
    remember_params = %{"remember_token" => nil}
    user
    |> User.changeset(remember_params)
    |> Repo.update! 
  end

  def random_characters do
    Fox.RandomExt.uniform(128)
    Fox.StringExt.random(128)
  end

  def authenticate(nil, _) do
    {:no, false}
  end

  def authenticate(user, password) do
    case Comeonin.Bcrypt.checkpw(password, user.password_hash) do
      true -> {:ok, user}
      _ -> false
    end
  end

  def logout!(conn) do
    conn |> current_user |> forget_me!
    conn = conn |> Plug.Conn.delete_session(:current_user)
    %Session{conn: conn}
  end

  def find_user_by_token(nil), do: nil
  def find_user_by_token(""), do: nil
  def find_user_by_token(token) do
    query = from u in User,
      where: u.remember_token == ^token,
      where: not is_nil(u.remember_token),
      select: u
    Repo.one query
  end

  def find_user_by_username(nil), do: nil
  def find_user_by_username(username) do
    query = from u in User,
      where: u.permalink == ^downcase(username),
      select: u
    Repo.one query
  end

  def find_user_by_email(nil), do: nil
  def find_user_by_email(email) do
    query = from u in User,
      where: u.email == ^downcase(email),
      select: u
    Repo.one query
  end

  def find_user_by_id(nil), do: nil
  def find_user_by_id(id) do
    query = from u in User,
      where: u.id == ^id,
      select: u
    Repo.one query
  end
end