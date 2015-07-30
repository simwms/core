defmodule Core.UserControllerTest do
  use Core.ConnCase

  alias Core.User
  @valid_attrs %{
    email: "test@test.co",
    password: "some content",
    remember_me: "true",
    username: "tester"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @valid_attrs 
    id = json_response(conn, 200)["user"]["id"]
    assert id

    user = Repo.get!(User, id)
    assert user
    assert user.password_hash
    assert user.username == @valid_attrs[:username]
    assert json_response(conn, 200)["user"]["email"] == @valid_attrs[:email]
    assert json_response(conn, 200)["user"]["username"] == @valid_attrs[:username]
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  # test "lists all entries on index", %{conn: conn} do
  #   conn = get conn, user_path(conn, :index)
  #   assert json_response(conn, 200)["data"] == []
  # end

  # test "shows chosen resource", %{conn: conn} do
  #   user = Repo.insert! %User{}
  #   conn = get conn, user_path(conn, :show, user)
  #   assert json_response(conn, 200)["data"] == %{
  #     "id" => user.id
  #   }
  # end

  # test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
  #   assert_raise Ecto.NoResultsError, fn ->
  #     get conn, user_path(conn, :show, -1)
  #   end
  # end

  # test "updates and renders chosen resource when data is valid", %{conn: conn} do
  #   user = Repo.insert! %User{}
  #   conn = put conn, user_path(conn, :update, user), user: @valid_attrs
  #   assert json_response(conn, 200)["data"]["id"]
  #   assert Repo.get_by(User, @valid_attrs)
  # end

  # test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
  #   user = Repo.insert! %User{}
  #   conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
  #   assert json_response(conn, 422)["errors"] != %{}
  # end

  # test "deletes chosen resource", %{conn: conn} do
  #   user = Repo.insert! %User{}
  #   conn = delete conn, user_path(conn, :delete, user)
  #   assert json_response(conn, 200)["data"]["id"]
  #   refute Repo.get(User, user.id)
  # end
end
