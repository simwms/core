defmodule Core.AccountTest do
  use Core.ModelCase

  alias Core.Account

  @valid_attrs %{access_key_id: "some content",
    company_name: "some content",
    host: "some content",
    namespace: "some content",
    secret_access_key: "some content", 
    timezone: "some content"}
  @invalid_attrs %{}

  test "changeset with invalid attributes" do
    changeset = Account.changeset(%Account{}, @invalid_attrs)
    refute changeset.valid?
  end
end
