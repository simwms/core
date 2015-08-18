defmodule Core.Repo.Migrations.SetupSeed do
  use Ecto.Migration

  def up do
    seed_user
    seed_accounts
    seed_service_plans
    seed_payment_subscriptions
  end

  def down do
    unseed_user
    unseed_accounts
    unseed_service_plans
    unseed_payment_subscriptions
  end

  @seed_user %{
    "email" => "test@test.test",
    "username" => "stage-test",
    "password" => "1234567" }
  defp seed_user do
    %Core.User{}
    |> Core.User.changeset(@seed_user)
    |> Core.Repo.insert!
  end

  defp unseed_user do
    Core.User
    |> Core.Repo.delete_all
  end

  @seed_accounts [
    %{
      "user_id" => 1,
      "company_name" => "Test Stage Co",
      "access_key_id" => "AKIAINYEM24JX5TX33LA",
      "secret_access_key" => "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",
      "timezone" => "American/Los_Angeles",
      "host" => "https://safe-forest-2497.herokuapp.com",
      "namespace" => "apiv2",
      "uiux_host" => "https://simwms.github.io/uiux",
      "config_host" => "https://simwms.github.io/config" 
    },
    %{
      "user_id" => 1,
      "company_name" => "Test Local Co",
      "access_key_id" => "AKIAINYEM24JX5TX33LA",
      "secret_access_key" => "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",
      "timezone" => "American/New_York",
      "host" => "http://localhost:4000",
      "namespace" => "apiv2",
      "uiux_host" => "https://simwms.github.io/uiux",
      "config_host" => "https://simwms.github.io/config" 
    }
  ]
  defp seed_accounts do
    @seed_accounts
    |> Enum.map(&seed_account/1)
  end
  defp unseed_accounts do
    Core.Account
    |> Core.Repo.delete_all
  end
  defp seed_account(seed) do
    %Core.Account{}
    |> Core.Account.changeset(seed)
    |> Core.Repo.insert!
  end

  @test_plan %{
    "presentation" => "Test",
    "version" => "seed",
    "description" => "Test plan, should not be visible for selection",
    "deprecated_at" => Ecto.DateTime.utc,
    "monthly_price" => 0
  }
  @free_trial_plan %{
    "presentation" => "Free Trial",
    "version" => "seed",
    "description" => "Trial plan lets you try out the software on a small pretend warehouse.",
    "monthly_price" => 0,
    "docks" => 1,
    "scales" => 1,
    "warehouses" => 4,
    "users" => 5,
    "availability" => 18,
    "appointments" => 10
  }
  @basic_plan %{
    "presentation" => "Small Business",
    "version" => "seed",
    "description" => "Basic plan is ideal for small warehouses with low traffic.",
    "monthly_price" => 5000,
    "docks" => 5,
    "scales" => 2,
    "warehouses" => 36,
    "users" => 10,
    "availability" => 24,
    "appointments" => 25
  }
  @standard_plan %{
    "presentation" => "Average Medium",
    "version" => "seed",
    "description" => "Standard plan for medium sized warehouses with high traffic.",
    "monthly_price" => 10000,
    "docks" => 10,
    "users" => 25,
    "availability" => 24,
    "appointments" => 75
  }
  @enterprise_plan %{
    "presentation" => "Large Enterprise",
    "version" => "seed",
    "description" => "Enterprise plan for large enterprise warehouses, no hard limits on anything.",
    "monthly_price" => 20000,
    "availability" => 24
  }
  @seed_plans [@test_plan, @free_trial_plan, @basic_plan, @standard_plan, @enterprise_plan]
  defp seed_service_plans do
    @seed_plans
    |> Enum.map(&seed_service_plan/1)
  end
  defp unseed_service_plans do
    Core.ServicePlan
    |> Core.Repo.delete_all
  end
  defp seed_service_plan(seed) do
    %Core.ServicePlan{}
    |> Core.ServicePlan.changeset(seed)
    |> Core.Repo.insert!
  end

  @subscriptions [
    %{
      "service_plan_id" => 1,
      "account_id" => 1,
      "user_id" => 1
    },
    %{
      "service_plan_id" => 1,
      "account_id" => 2,
      "user_id" => 1
    }
  ]
  defp unseed_payment_subscriptions do
    Core.PaymentSubscription
    |> Core.Repo.delete_all
  end
  defp seed_payment_subscriptions do
    @subscriptions
    |> Enum.map(&seed_payment_subscription/1)
  end
  defp seed_payment_subscription(seed) do
    %Core.PaymentSubscription{}
    |> Core.PaymentSubscription.changeset(seed)
    |> Core.Repo.insert!
  end
end
