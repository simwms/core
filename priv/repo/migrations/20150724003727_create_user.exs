defmodule Core.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def up do
    create table(:users) do
      add :email, :string, null: false, default: ""
      add :username, :string, null: false, default: ""
      add :password_hash, :string
      add :recovery_hash, :string
      add :remember_token, :string
      add :forget_at, :datetime
      add :remembered_at, :datetime
      add :stripe_customer_id, :string
      
      timestamps
    end
    create index(:users, [:email], unique: true)
    create index(:users, [:username], unique: true)
    create index(:users, [:remember_token])
    create index(:users, [:recovery_hash], unique: true)
  end

  def down do
    drop table(:users)
  end

end
