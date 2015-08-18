defmodule Core.AccountCreator do
  alias __MODULE__
  alias Core.Account
  alias Core.Repo
  alias Core.PaymentSubscription
  alias Core.AccountQuery
  defstruct errors: [],
    success?: false,
    amazon: {:no, nil},
    heroku: {:no, nil},
    account: nil,
    changeset: nil,
    user: %{id: nil},
    payment_subscription: %{id: nil},
    params: %{}
  def attempt_build!({user, params}) do
    {user, params}
    |> setup_creator
    |> request_amazon_access_keys
    |> spinup_heroku_instance
    |> persist_to_database
    |> setup_payment_subscription
  end

  def attempt_cleanup!(results) do
    results
  end

  def setup_creator({user, params}) do
    %AccountCreator{ params: params, user: user }
  end

  def request_amazon_access_keys(creator) do
    creator # Not implemented
  end

  def spinup_heroku_instance(creator) do
    creator # Not implemented
  end

  def persist_to_database(%{params: account_params, user: user}=creator) do
    params = account_params
    |> Dict.put("user_id", user.id)
    |> Dict.put("access_key_id", "not-implemented-id")
    |> Dict.put("secret_access_key", "not-implemented-key")
    |> Dict.put("namespace", "whatever")
    |> Dict.put("host", "http://example.com")
    
    changeset = Account.changeset(%Account{}, params)

    if changeset.valid? do
      account = Repo.insert!(changeset)
      %{creator | account: account, success?: true }
    else
      %{creator | changeset: changeset }
    end
  end

  def setup_payment_subscription(%{success?: false}=creator), do: creator
  def setup_payment_subscription(%{account: account}=creator) do
    ps = account |> PaymentSubscription.free_trial
    account = account |> Repo.preload(AccountQuery.preload_fields)
    %{creator | payment_subscription: ps, account: account }
  end
end