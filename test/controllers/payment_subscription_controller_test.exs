defmodule Core.PaymentSubscriptionControllerTest do
  use Core.ConnCase

  @register_attrs %{
    username: "tester",
    email: "test@test.co",
    password: "password"}
  @login_attrs %{
    "email" => "test@test.co",
    "password" => "password"}
  @account_attrs %{
    "company_name" => "Dog Food Test Co",
    "timezone" => "Americas/Los_Angeles"}

  @payment_attrs %{
    "source" => %{
      "object" => "card",
      "number" => "4242424242424242",
      "exp_month" => 12,
      "exp_year" => 25,
      "cvc" => "666",
      "name" => "Roxy Monster"
    },
    "service_plan_id" => 4
  }

  setup do
    user = Core.User.changeset(%Core.User{}, @register_attrs) |> Repo.insert!
    {:ok, creator} = {user, @account_attrs} |> Core.AccountCreator.attempt_build!
    conn = conn() 
    |> put_req_header("accept", "application/json")
    |> post( session_path(conn, :create), session: @login_attrs )
    {:ok, conn: conn, user: user, account: creator.account}
  end

  test "it should allow me to update my subscription", %{conn: conn, account: account, user: user} do
    subscription = account.payment_subscription
    response = conn
    |> put( payment_subscription_path(conn, :update, subscription), payment_subscription: @payment_attrs)
    |> json_response(200)
    result = response["payment_subscription"]
    assert result
    assert result["id"]
    assert result["service_plan_id"] == 4
    assert result["account_id"] == account.id
    assert result["user_id"] == user.id

    service_plan = Core.Repo.get!(Core.ServicePlan, 4)
    %{stripe_customer_id: cus_id} = Repo.get!(Core.User, user.id)
    %{stripe_subscription_id: id} = Repo.get!(Core.PaymentSubscription, subscription.id)
    assert cus_id
    assert id
    stripe_subscription = {cus_id, id} |> Stripex.Subscriptions.retrieve
    assert stripe_subscription
    assert stripe_subscription.id == id
    assert stripe_subscription.plan["id"] == service_plan.stripe_plan_id

    subscriptions = cus_id |> Stripex.Subscriptions.all
    assert Enum.count(subscriptions) == 1
  end

  test "it should allow me to delete subscription", %{conn: conn, account: account, user: user} do
    free_trial = Core.ServicePlan.free_trial
    subscription = account.payment_subscription
    %{"payment_subscription" => result} = conn
    |> delete( payment_subscription_path(conn, :delete, subscription), id: subscription.id)
    |> json_response(200)
    assert result["service_plan_id"] == free_trial.id

    %{stripe_customer_id: cus_id} = Repo.get!(Core.User, user.id)
    subscriptions = cus_id |> Stripex.Subscriptions.all
    assert Enum.count(subscriptions) == 0
  end
end