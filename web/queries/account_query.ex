defmodule Core.AccountQuery do
  import Ecto.Query, only: [from: 2]
  import Ecto.Model, only: [assoc: 2]

  def index({user, params}) do
    from a in assoc(user, :accounts),
      select: a
  end
end