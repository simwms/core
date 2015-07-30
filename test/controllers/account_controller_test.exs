defmodule Core.AccountControllerTest do
  use Core.ConnCase

  @register_attrs %{
    username: "tester",
    email: "test@test.co",
    password: "password"}
  @login_attrs %{
    "email" => "test@test.co",
    "password" => "password"}
  @valid_attrs %{
    "company_name" => "Dog Food Test Co",
    "timezone" => "Americas/Los_Angeles"}
  @bad_attrs %{}

  setup do
    Core.User.changeset(%Core.User{}, @register_attrs) |> Repo.insert!
    conn = conn() 
    |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "it should forbid a bad user from getting in", %{conn: conn} do
    response = conn
    |> post( account_path(conn, :create), account: @valid_attrs )
    |> json_response(403)
    assert response["msg"] == "Not logged in"
  end

  test "it should create an account", %{conn: conn} do
    response = conn
    |> post( session_path(conn, :create), session: @login_attrs )
    |> post( account_path(conn, :create), account: @valid_attrs )
    |> json_response(200)
    assert response["account"]
    assert response["account"]["company_name"] == @valid_attrs["company_name"]
    assert response["account"]["timezone"] == @valid_attrs["timezone"]
    assert response["account"]["user_id"]
    assert response["account"]["access_key_id"]
    assert response["account"]["secret_access_key"]
    
  end
end