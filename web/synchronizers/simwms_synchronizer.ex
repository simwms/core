defmodule Core.SimwmsSynchronizer do
  alias Core.Account
  alias Core.Repo

  def synchronize(%{simwms_account_key: id}=account) when is_binary(id) do
    params = account |> generate_params!
    {:ok, _} = id |> Simwms.Accounts.update(params)
    account
  end

  def synchronize(account) do
    {:ok, simwms_account} = account |> generate_params! |> Simwms.Accounts.create
    simwms_account |> generate_changeset(account) |> Repo.update!
  end

  defp generate_changeset(%{permalink: permalink}, local_account) do
    changes = %{simwms_account_key: permalink}
    local_account |> Ecto.Changeset.change(changes)
  end

  defp generate_params!(account) do
    %{stripe_plan_id: plan_id} = account |> Account.get_service_plan
    %{email: email} = account |> Account.get_user
    %{
      "account" => %{
        "service_plan_id" => plan_id,
        "timezone" => account.timezone,
        "email" => email,
        "access_key_id" => account.access_key_id,
        "secret_access_key" => account.secret_access_key
      }
    }
  end
end