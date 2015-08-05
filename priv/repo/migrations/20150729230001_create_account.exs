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
      add :service_plan, :string
      add :uiux_host, :string
      add :config_host, :string

      timestamps
    end
    create index(:accounts, [:user_id])
    seed_accounts
  end

  def down do
    drop table(:accounts)
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
      "service_plan" => "test",
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
      "service_plan" => "test",
      "uiux_host" => "https://simwms.github.io/uiux",
      "config_host" => "https://simwms.github.io/config" 
    }
  ]
  defp seed_accounts do
    @seed_accounts
    |> Enum.map(&seed_account/1)
  end
  defp seed_account(seed) do
    %Core.Account{}
    |> Core.Account.changeset(seed)
    |> Core.Repo.insert!
  end
end
