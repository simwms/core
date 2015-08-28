# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Core.Repo.insert!(%SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
defmodule Seeds do
  def plant do
    user = seed_user
    [stage_account, local_account] = user |> seed_accounts
    [plan|_] = seed_plans
    %{account: stage_account, plan: plan} |> seed_payment_subscription
    %{account: local_account, plan: plan} |> seed_payment_subscription
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

  @seed_accounts [
    %{
      "company_name" => "Test Stage Co",
      "access_key_id" => "AKIAINYEM24JX5TX33LA",
      "secret_access_key" => "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",
      "timezone" => "America/Los_Angeles",
      "host" => "https://evening-springs-7575.herokuapp.com",
      "uiux_host" => "https://simwms.github.io/uiux",
      "config_host" => "https://simwms.github.io/config" 
    },
    %{
      "company_name" => "Test Local Co",
      "access_key_id" => "AKIAINYEM24JX5TX33LA",
      "secret_access_key" => "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",
      "timezone" => "America/New_York",
      "host" => "http://localhost:4000",
      "uiux_host" => "https://simwms.github.io/uiux",
      "config_host" => "https://simwms.github.io/config" 
    }
  ]
  defp seed_accounts(user) do
    @seed_accounts
    |> Enum.map(&seed_account/1)
  end
  defp seed_account(user, seed) do
    user
    |> Ecto.Model.build(:accounts)
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
  defp seed_service_plan(seed) do
    %Core.ServicePlan{}
    |> Core.ServicePlan.changeset(seed)
    |> Core.Repo.insert!
  end

  defp seed_payment_subscription(%{account: account, plan: plan}) do
    seed = %{account_id: account.id, service_plan_id: plan.id}
    %Core.PaymentSubscription{}
    |> Core.PaymentSubscription.changeset(seed)
    |> Core.Repo.insert!
  end
end
Seeds.plant