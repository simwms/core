defmodule Core.ServicePlanControllerTest do
  use Core.ConnCase

  alias Core.ServicePlan
  @valid_attrs %{
    appointments: 42, 
    availability: 42, 
    description: "some content", 
    docks: 42, 
    monthly_price: "120.5", 
    presentation: "some content", 
    scales: 42, 
    users: 42,  
    warehouses: 42
  }
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, service_plan_path(conn, :index)
    assert json_response(conn, 200)["service_plans"]
  end

  test "shows chosen resource", %{conn: conn} do
    service_plan = Repo.insert! %ServicePlan{}
    conn = get conn, service_plan_path(conn, :show, service_plan)
    assert json_response(conn, 200)["service_plan"]
  end

  # test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
  #   assert_raise Ecto.NoResultsError, fn ->
  #     get conn, service_plan_path(conn, :show, -1)
  #   end
  # end

  # test "creates and renders resource when data is valid", %{conn: conn} do
  #   conn = post conn, service_plan_path(conn, :create), service_plan: @valid_attrs
  #   assert json_response(conn, 200)["data"]["id"]
  #   assert Repo.get_by(ServicePlan, @valid_attrs)
  # end

  # test "does not create resource and renders errors when data is invalid", %{conn: conn} do
  #   conn = post conn, service_plan_path(conn, :create), service_plan: @invalid_attrs
  #   assert json_response(conn, 422)["errors"] != %{}
  # end

  # test "updates and renders chosen resource when data is valid", %{conn: conn} do
  #   service_plan = Repo.insert! %ServicePlan{}
  #   conn = put conn, service_plan_path(conn, :update, service_plan), service_plan: @valid_attrs
  #   assert json_response(conn, 200)["data"]["id"]
  #   assert Repo.get_by(ServicePlan, @valid_attrs)
  # end

  # test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
  #   service_plan = Repo.insert! %ServicePlan{}
  #   conn = put conn, service_plan_path(conn, :update, service_plan), service_plan: @invalid_attrs
  #   assert json_response(conn, 422)["errors"] != %{}
  # end

  # test "deletes chosen resource", %{conn: conn} do
  #   service_plan = Repo.insert! %ServicePlan{}
  #   conn = delete conn, service_plan_path(conn, :delete, service_plan)
  #   assert json_response(conn, 200)["data"]["id"]
  #   refute Repo.get(ServicePlan, service_plan.id)
  # end
end
