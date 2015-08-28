defmodule Core.AccountTest do
  use Core.ModelCase

  alias Core.Account

  @valid_attrs %{
    company_name: "some content",
    timezone: "some content"
  }
  @full_attrs %{
    company_name: "some content",
    uiux_host: "uiux.github.io",
    config_host: "config.github.io",
    access_key_id: "aws666",
    secret_access_key: "hailsatan",
    host: "http://somewhere.co",
    namespace: "apiv4",
    simwms_account_key: "ashita-o-sagashite",
    stripe_customer_id: "cus_23842h",
    timezone: "some content"
  }
  @invalid_attrs %{}

  test "changeset with invalid attributes" do
    changeset = Account.changeset(%Account{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "accounts should be properly setup if all their fields are filled" do
    [user|_] = Core.User |> Repo.all
    account = user |> build(:accounts) |> Account.changeset(@valid_attrs) |> Repo.insert!
    refute account.is_properly_setup

    account = account |> Account.changeset(@full_attrs) |> Repo.update!
    assert account.uiux_host == @full_attrs[:uiux_host]
    assert account.config_host == @full_attrs[:config_host]
    assert account.access_key_id == @full_attrs[:access_key_id]
    assert account.secret_access_key == @full_attrs[:secret_access_key]
    assert account.host == @full_attrs[:host]
    assert account.namespace == @full_attrs[:namespace]
    assert account.simwms_account_key == @full_attrs[:simwms_account_key]
    assert account.is_properly_setup == true
  end
end
