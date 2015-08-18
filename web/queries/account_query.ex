defmodule Core.AccountQuery do
  import Ecto.Query, only: [from: 2]
  import Ecto.Model, only: [assoc: 2]

  @preload_fields [:user, payment_subscription: :service_plan]
  def preload_fields, do: @preload_fields

  def index({user, _params}) do
    from a in assoc(user, :accounts),
      select: a
  end
end