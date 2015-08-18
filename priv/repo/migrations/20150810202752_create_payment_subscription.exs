defmodule Core.Repo.Migrations.CreatePaymentSubscription do
  use Ecto.Migration

  def up do
    create table(:payment_subscriptions) do
      add :stripe_subscription_id, :string
      add :service_plan_id, :integer
      add :account_id, :integer
      add :stripe_token, :string
      add :token_already_consumed, :boolean, default: false
      timestamps
    end
    create index(:payment_subscriptions, [:account_id])
  end

  def down do
    drop table(:payment_subscriptions)
  end
end