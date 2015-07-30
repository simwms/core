defmodule Core.Account do
  use Core.Web, :model

  schema "accounts" do
    field :company_name, :string
    field :access_key_id, :string
    field :secret_access_key, :string
    field :timezone, :string
    field :host, :string
    field :namespace, :string
    field :service_plan, :string
    belongs_to :user, Core.User

    timestamps
  end

  @required_fields ~w(company_name access_key_id secret_access_key timezone host namespace user_id)
  @optional_fields ~w(service_plan)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
