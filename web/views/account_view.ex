defmodule Core.AccountView do
  use Core.Web, :view
  import Fox.DictExt, only: [reject_blank_keys: 1]
  def render("index.json", %{accounts: accounts}) do
    %{accounts: render_many(accounts, "account.json")}
  end

  def render("show.json", %{account: account}) do
    %{account: render_one(account, "account.json")}
  end

  def render("account.json", %{account: account}) do
    account |> ember_attributes |> reject_blank_keys
  end

  def ember_attributes(account) do
    %{id: account.id,
      company_name: account.company_name,
      access_key_id: account.access_key_id,
      secret_access_key: account.secret_access_key,
      timezone: account.timezone,
      host: account.host,
      namespace: account.namespace,
      service_plan: account.service_plan,
      user_id: account.user_id,
      inserted_at: account.inserted_at}
  end
end
