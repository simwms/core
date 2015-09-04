defmodule Core.Repo.Migrations.AddSetupAttemptsToAccounts do
  use Ecto.Migration

  def change do
    alter table(:accounts) do
      add :setup_attempts, :integer, default: 0
    end
  end
end
