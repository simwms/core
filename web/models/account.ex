defmodule Core.Account do
  use Core.Web, :model

  schema "accounts" do
    field :company_name, :string
    field :access_key_id, :string
    field :secret_access_key, :string
    field :timezone, :string
    field :host, :string
    field :namespace, :string
    field :uiux_host, :string
    field :config_host, :string
    belongs_to :user, Core.User
    has_one :stripe_customer_id, through: [:user, :stripe_customer_id]
    has_one :payment_subscription, Core.PaymentSubscription
    has_one :service_plan, through: [:payment_subscription, :service_plan]

    timestamps
  end

  @required_fields ~w(company_name access_key_id secret_access_key timezone host namespace user_id)
  @optional_fields ~w(uiux_host config_host)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def synchronize_stripe(account) do
    account = account |> Repo.preload(:user)
    account.user |> Core.User.synchronize_stripe
    account
  end
end
