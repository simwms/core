defmodule Core.UserTest do
  use Core.ModelCase

  alias Core.User

  @valid_attrs %{
    email: "test@test.co", 
    forget_at: %{day: 17, hour: 14, min: 0, month: 4, year: 2010}, 
    password: "some content", 
    username: "tester"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
