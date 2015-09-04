defmodule Core.AccountSynchronizerTest do
  use Core.ModelCase
  alias Core.AccountSynchronizer
  alias Core.Account
  @account_attrs %{
    "company_name" => "Dog Food Test Co",
    "timezone" => "Americas/Los_Angeles"}
  @register_attrs %{
    username: "tester",
    email: "test@test.co",
    password: "password"}
  
  setup do
    user = %Core.User{} |> Core.User.changeset(@register_attrs) |> Repo.insert!
    account = user |> build(:accounts) |> Account.changeset(@account_attrs) |> Repo.insert!
    
    {:ok, user: user, account: account}
  end

  test "synchronization should properly setup the account", %{account: account} do
    account = account |> AccountSynchronizer.synchronize!
    service_plan = account |> assoc(:service_plan) |> Repo.one!
    assert account.setup_attempts > 0
    assert account.simwms_account_key
    assert account.access_key_id
    assert account.secret_access_key
    assert account.is_properly_setup
    assert service_plan == Core.ServicePlan.free_trial
  end

  test "synchronization should work as a job", %{account: account} do
    %{id: id} = account
    {:ok, pid} = account |> Accver.synchronize(self)
    assert_receive {:try, ^id}, 1000
    refute pid == self
    assert_receive {:done, ^id}, 1000
    account = Account |> Repo.get!(id)
    assert account.setup_attempts > 0
    assert account.is_properly_setup
  end
end