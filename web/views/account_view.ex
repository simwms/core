defmodule Core.AccountView do
  use Core.Web, :view
  import Fox.DictExt, only: [reject_blank_keys: 1]
  def render("index.json", %{accounts: accounts}) do
    %{accounts: render_many(accounts, __MODULE__, "account.json")}
  end

  def render("show.json", %{account: account}) do
    %{account: render_one(account, __MODULE__, "account.json")}
  end

  def render("account.json", %{account: account}) do
    account |> ember_attributes |> reject_blank_keys
  end

  def ember_attributes(account) do
    plan_id = account.payment_subscription.service_plan_id
    %{id: account.id,
      company_name: account.company_name,
      access_key_id: account.access_key_id,
      secret_access_key: account.secret_access_key,
      timezone: account.timezone,
      host: account.host,
      namespace: account.namespace,
      service_plan_id: plan_id,
      payment_subscription_id: account.payment_subscription.id,
      is_properly_setup: account.is_properly_setup,
      uiux_host: account.uiux_host,
      config_host: account.config_host,
      simwms_account_key: account.simwms_account_key,
      user_id: account.user_id,
      inserted_at: account.inserted_at}
  end
end
