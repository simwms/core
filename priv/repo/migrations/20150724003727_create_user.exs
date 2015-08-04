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

      timestamps
    end
    create index(:users, [:email], unique: true)
    create index(:users, [:username], unique: true)
    create index(:users, [:remember_token])
    create index(:users, [:recovery_hash], unique: true)
    seed_user
  end

  def down do
    drop table(:users)
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
end
