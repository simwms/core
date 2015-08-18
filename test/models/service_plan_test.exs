defmodule Core.ServicePlanTest do
  use Core.ModelCase

  alias Core.ServicePlan

  @valid_attrs %{
    appointments: 42, 
    availability: 42, 
    description: "some content", 
    docks: 42, 
    monthly_price: 12050, 
    presentation: "some content", 
    scales: 42, 
    users: 42,  
    warehouses: 42
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ServicePlan.changeset(%ServicePlan{}, @valid_attrs)
    permalink = changeset |> Ecto.Changeset.get_field(:permalink)
    assert permalink
    assert changeset.errors == []
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ServicePlan.changeset(%ServicePlan{}, @invalid_attrs)
    refute changeset.valid?
  end
end
