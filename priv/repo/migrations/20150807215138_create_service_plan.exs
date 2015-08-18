defmodule Core.Repo.Migrations.CreateServicePlan do
  use Ecto.Migration

  def up do
    create table(:service_plans) do
      add :stripe_plan_id, :string
      add :permalink, :string
      add :version, :string
      add :presentation, :string
      add :description, :string
      add :monthly_price, :integer # in cents
      add :docks, :integer
      add :scales, :integer
      add :warehouses, :integer
      add :users, :integer
      add :availability, :integer
      add :appointments, :integer
      add :deprecated_at, :datetime
      timestamps
    end
    create index(:service_plans, [:permalink])
  end

  def down do
    drop table(:service_plans)
  end
end