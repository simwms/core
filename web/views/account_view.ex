defmodule Core.AccountView do
  use Pipe
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
    core = ember_core_attributes(account)
    stripe = stripe_attributes(account)
    simwms = simwms_attributes(account)

    core |> Dict.merge(stripe) |> Dict.merge(simwms)
  end
  
  def ember_core_attributes(account) do
    %{
      id: account.id,
      company_name: account.company_name,
      access_key_id: account.access_key_id,
      secret_access_key: account.secret_access_key,
      timezone: account.timezone,
      host: account.host,
      namespace: account.namespace,
      user_id: account.user_id,
      uiux_host: account.uiux_host,
      config_host: account.config_host,
      inserted_at: account.inserted_at,
      is_properly_setup: account.is_properly_setup,
      setup_attempts: account.setup_attempts
    }
  end

  def stripe_attributes(%{payment_subscription: %Ecto.Association.NotLoaded{}}), do: %{}
  def stripe_attributes(%{payment_subscription: nil}), do: %{}
  def stripe_attributes(%{payment_subscription: subscription}) do
    %{ payment_subscription_id: subscription.id,
       service_plan_id: subscription.service_plan_id }
  end

  def simwms_attributes(account) do
    %{simwms_account_key: account.simwms_account_key}
  end

end
