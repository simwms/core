defmodule Core.AccountCreator do
  use Pipe
  alias __MODULE__
  alias Core.Account
  alias Core.Repo
  alias Core.PaymentSubscription
  alias Core.AccountQuery
  import Ecto.Model
  defstruct errors: [],
    success?: false,
    amazon: nil,
    simwms: nil,
    changeset: nil,
    account: nil,
    user: nil,
    payment_subscription: nil,
    params: %{}
  def attempt_build!({user, params}) do
    pipe_with &pass_ok_fail_error/2,
      setup_creator(user, params)
      |> initialize_in_database
      |> request_amazon_access_keys
      |> spinup_simwms_instance
      |> setup_payment_subscription
      |> complete_to_database
  end

  defp pass_ok_fail_error({:error, _}=c, _), do: c
  defp pass_ok_fail_error({:ok, creator}, f), do: f.(creator)

  def setup_creator(user, params) do
    {:ok, %AccountCreator{ params: params, user: user }}
  end

  def initialize_in_database(%{params: params, user: user}=creator) do
    changeset = user
    |> build(:accounts)
    |> Account.changeset(params)
    if changeset.valid? do
      account = Repo.insert! changeset
      {:ok, %{creator | account: account }}
    else
      {:error, %{creator | changeset: changeset }}
    end
  end

  def request_amazon_access_keys(creator) do
    amazon = Application.get_env(:gateway, Amazon)
    {:ok, %{creator|amazon: amazon}}
  end

  def spinup_simwms_instance(%{params: params}=creator) do
    results = params
    |> simwms_account_paramify(creator)
    |> Simwms.Accounts.create
    case results do
      {:ok, account} -> {:ok, %{creator | simwms: account, success?: true}}
      {:error, error} -> {:error, %{creator | changeset: %{errors: error}}}
    end
  end

  def setup_payment_subscription(%{success?: false}=creator), do: {:error, creator} 
  def setup_payment_subscription(%{account: account}=creator) do
    ps = account |> PaymentSubscription.free_trial
    account = account |> Repo.preload(AccountQuery.preload_fields)
    {:ok, %{creator | payment_subscription: ps, account: account }}
  end


  def complete_to_database(%{account: account, simwms: simwms, amazon: amazon}=creator) do
    if simwms.permalink do
      changes = %{
        simwms_account_key: simwms.permalink,
        access_key_id: amazon[:access_key_id],
        secret_access_key: amazon[:secret_access_key]
      }
      changeset = Ecto.Changeset.change(account, changes)
      account = Repo.update!(changeset)
      {:ok, %{creator | account: account }}
    else
      {:error, %{creator | success?: false}}
    end
  end

  defp simwms_account_paramify(%{"timezone" => tz}, creator) do
    plan_id = Core.ServicePlan.free_trial.permalink
    user = creator.account |> assoc(:user) |> Repo.one!
    amazon = creator.amazon
    %{
      "account" => %{
        "service_plan_id" => plan_id,
        "timezone" => tz,
        "email" => user.email,
        "access_key_id" => amazon[:access_key_id],
        "secret_access_key" => amazon[:secret_access_key]
      }
    }
  end
end