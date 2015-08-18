defmodule Core.ServicePlanQuery do
  import Ecto.Query, only: [from: 2]
  # import Ecto.Model, only: [assoc: 2]
  alias Core.ServicePlan

  def index(_params) do
    from s in ServicePlan,
      where: is_nil(s.deprecated_at),
      select: s
  end

  def free_trial do
    from s in ServicePlan,
      where: s.permalink == "free-trial-seed",
      select: s
  end

end