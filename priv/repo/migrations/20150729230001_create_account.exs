defmodule Core.Repo.Migrations.CreateAccount do
  use Ecto.Migration

  def up do
    create table(:accounts) do
      add :company_name, :string
      add :access_key_id, :string
      add :secret_access_key, :string
      add :timezone, :string
      add :host, :string
      add :namespace, :string
      add :user_id, :integer
      add :uiux_host, :string
      add :config_host, :string

      timestamps
    end
    create index(:accounts, [:user_id])
  end

  def down do
    drop table(:accounts)
  end
end