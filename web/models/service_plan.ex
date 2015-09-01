defmodule Core.ServicePlan do
  use Core.Web, :model

  schema "service_plans" do
    field :permalink, :string
    field :version, :string
    field :presentation, :string
    field :description, :string
    field :monthly_price, :integer
    field :docks, :integer
    field :scales, :integer
    field :warehouses, :integer
    field :users, :integer
    field :availability, :integer
    field :appointments, :integer
    field :deprecated_at, Ecto.DateTime
    field :stripe_plan_id, :string
    timestamps
  end

  @required_fields ~w(presentation description)
  @optional_fields ~w(permalink
    stripe_plan_id
    version 
    monthly_price 
    docks 
    scales 
    warehouses 
    users 
    availability 
    appointments
    deprecated_at)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> punch_permalink
  end

  def free_trial do 
    __MODULE__ |> Repo.get_by!(permalink: "free-trial-seed") |> synchronize_stripe
  end

  def punch_permalink(changeset) do
    case changeset |> get_field(:permalink) do
      nil ->
        permalink = changeset |> get_field(:presentation) |> Fox.StringExt.to_url
        version = changeset |> get_field(:version)
        changeset |> put_change(:permalink, "#{permalink}-#{version}")
      _ -> changeset
    end
  end

  def synchronize_stripe(service_plan) do
    case service_plan.stripe_plan_id do
      nil -> initialize_stripe(service_plan)
      _ -> service_plan
    end
  end

  defp initialize_stripe(service_plan) do
    {:ok, stripe_plan} = find_or_create_stripe_plan service_plan

    service_plan
    |> changeset(%{"stripe_plan_id" => stripe_plan.id})
    |> Repo.update!
  end

  defp find_or_create_stripe_plan(service_plan) do
    case service_plan.permalink |> Stripex.Plans.retrieve do
      {:error, %{status_code: 404}} -> 
        Stripex.Plans.create id: service_plan.permalink,
          amount: service_plan.monthly_price,
          currency: "usd",
          name: service_plan.presentation,
          interval: "month",
          statement_descriptor: "simwms cloud service"
      {:ok, plan} -> {:ok, plan}
    end
  end

end
