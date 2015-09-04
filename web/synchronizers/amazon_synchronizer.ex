defmodule Core.AmazonSynchronizer do
  alias Core.Repo

  def synchronize(account) do
    amazon = Application.get_env(:gateway, Amazon)
    account = amazon |> generate_changeset(account) |> Repo.update!
  end

  def generate_changeset(amazon, account) do
    changes = %{access_key_id: amazon[:access_key_id], secret_access_key: amazon[:secret_access_key]}
    account |> Ecto.Changeset.change(changes)
  end
end