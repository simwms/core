defmodule Core.AccountCreator do
  alias __MODULE__
  alias Core.Account
  alias Core.Repo
  alias Ecto.Changeset, as: C
  defstruct errors: [],
    success?: false,
    amazon: {:no, nil},
    heroku: {:no, nil},
    database: {:no, nil},
    user: %{id: nil},
    params: %{}
  def attempt_build!({user, params}) do
    {user, params}
    |> setup_creator
    |> request_amazon_access_keys
    |> spinup_heroku_instance
    |> persist_to_database
  end

  def attempt_cleanup!(results) do
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
      %{creator | database: {:ok, account}, success?: true }
    else
      %{creator | database: {:error, changeset} }
    end
  end
end