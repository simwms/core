defmodule Core.SessionControllerTest do
  use Core.ConnCase

  alias Core.Session
  @register_attr %{
    username: "tester",
    email: "test@test.co",
    password: "password"}
    
  @valid_attrs %{
    email: "test@test.co",
    password: "password"}
  @remember_attrs %{
    email: "test@test.co",
    password: "password",
    remember_me: true}
    
  @invalid_attrs %{email: "test@test.co", password: "wrong-password"}

  setup do
    Core.User.changeset(%Core.User{}, @register_attr) |> Repo.insert!
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "it should log the user in", %{conn: conn} do
    conn = post conn, session_path(conn, :create), session: @valid_attrs 
    user = Session.current_user(conn)
    assert user
    assert user.id
    assert user.email == @register_attr[:email]
    assert user.username == @register_attr[:username]
  end

  test "it should log the user out", %{conn: conn} do
    conn = conn
    |> post( session_path(conn, :create), session: @valid_attrs )
    |> delete( session_path(conn, :delete), session: %{} )
    
    user = conn |> Session.current_user
    refute Session.logged_in?(conn)
    refute user
  end

  test "it should properly spit out the expected response", %{conn: conn} do
    conn = post conn, session_path(conn, :create), session: @valid_attrs
    response = json_response(conn, 200)
    assert response["session"]
    assert response["session"]["id"]
    assert response["session"]["user"]
  end

  test "it should allow users to be remembered", %{conn: conn} do
    conn = post conn, session_path(conn, :create), session: @remember_attrs
    user = Session.current_user(conn)
    assert user.remember_token
    response = json_response(conn, 200)
    assert response["session"]["id"]
    assert response["session"]["user"]
    assert response["session"]["remember_token"] == user.remember_token
  end

  test "it should properly inform me I have a wrong pass", %{conn: conn} do
    conn = post conn, session_path(conn, :create), session: @invalid_attrs
    response = json_response(conn, :unprocessable_entity)
    assert response["errors"]
    e1 = List.first response["errors"]
    assert e1
    assert e1["key"] == "password"
    assert e1["msg"] == "wrong"
  end
end