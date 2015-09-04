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
    user = Core.User.changeset(%Core.User{}, @register_attrs) |> Repo.insert!
    conn = conn() 
    |> put_req_header("accept", "application/json")
    {:ok, conn: conn, user: user}
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
    # assert response["account"]["service_plan_id"] == 2
    assert response["account"]["uiux_host"]
    assert response["account"]["config_host"]
    # assert response["account"]["access_key_id"]
    # assert response["account"]["secret_access_key"]
    assert response["account"]["host"]
    assert response["account"]["namespace"]
    # assert response["account"]["simwms_account_key"]
    assert response["account"]["is_properly_setup"] == false
  end

  test "it should let me access the index with the proper user token", %{conn: conn, user: user} do
    %{remember_token: token } = user |> Core.Session.update_remember_me_token!
    response = conn
    |> put_req_header("remember_token", token)
    |> get( account_path(conn, :index) )
    |> json_response(200)
    assert response["accounts"]
  end
end