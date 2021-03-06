defmodule Core.Account do
  use Core.Web, :model
  @simwms_defaults Application.get_env(:gateway, Simwms)
  
  schema "accounts" do
    field :company_name, :string
    field :timezone, :string
    field :access_key_id, :string
    field :secret_access_key, :string
    field :host, :string, default: @simwms_defaults[:url]
    field :namespace, :string, default: @simwms_defaults[:namespace]
    field :uiux_host, :string, default: @simwms_defaults[:uiux_host]
    field :config_host, :string, default: @simwms_defaults[:config_host]
    field :simwms_account_key, :string
    field :is_properly_setup, :boolean, default: false
    field :setup_attempts, :integer, default: 0
    belongs_to :user, Core.User
    has_one :stripe_customer_id, through: [:user, :stripe_customer_id]
    has_one :payment_subscription, Core.PaymentSubscription
    has_one :service_plan, through: [:payment_subscription, :service_plan]

    timestamps
  end

  @required_fields ~w(company_name timezone)
  @optional_fields ~w(
    uiux_host
    config_host
    access_key_id
    secret_access_key
    host
    namespace
    simwms_account_key
    is_properly_setup
  )
  
  def createset(model, params\\:empty) do
    model |> cast(params, @required_fields)
  end
  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def get_service_plan(%{service_plan: %Core.ServicePlan{}=plan}), do: plan
  def get_service_plan(account) do
    account |> assoc(:service_plan) |> Repo.one
  end

  def get_user(%{user: %Core.User{}=user}), do: user
  def get_user(account) do
    account |> assoc(:user) |> Repo.one
  end 

  def increment_attempt!(%{setup_attempts: n}=account) do
    account
    |> change(setup_attempts: n + 1)
    |> Repo.update!
  end

  def ensure_payment_subscription(account) do
    case account.payment_subscription do
      nil -> account |> Core.PaymentSubscription.free_trial
      payment_subscription when not is_nil(payment_subscription) -> payment_subscription
    end
  end

  def synchronize_stripe(account) do
    account = account |> Repo.preload(:user)
    account.user |> Core.User.synchronize_stripe
    account
  end

  before_update :check_proper_setup
  @doc """
  If all the optional fields have values, then the account is properly setup
  """
  def check_proper_setup(changeset) do
    x = changeset |> all_fields_present?
    changeset |> put_change(:is_properly_setup, x)
  end

  defp all_fields_present?(changeset) do
    @optional_fields
    |> Enum.map(&String.to_existing_atom/1)
    |> Enum.all?(&has_value?(changeset, &1))
  end

  defp has_value?(changeset, key) do
    case changeset |> fetch_field(key) do
      {_, x} when not is_nil x -> true
      _ -> false
    end
  end
end
