defmodule Core.ServicePlanView do
  use Core.Web, :view

  def render("index.json", %{service_plans: service_plans}) do
    %{service_plans: render_many(service_plans, __MODULE__, "service_plan.json")}
  end

  def render("show.json", %{service_plan: service_plan}) do
    %{service_plan: render_one(service_plan, __MODULE__, "service_plan.json")}
  end

  def render("service_plan.json", %{service_plan: service_plan}) do
    service_plan |> ember_attributes |> Fox.DictExt.reject_blank_keys
  end

  def ember_attributes(plan) do
    %{
      id: plan.id,
      permalink: plan.permalink,
      version: plan.version,
      presentation: plan.presentation,
      description: plan.description,
      monthly_price: plan.monthly_price,
      docks: plan.docks,
      scales: plan.scales,
      warehouses: plan.warehouses,
      users: plan.users,
      availability: plan.availability,
      appointments: plan.appointments,
      deprecated_at: plan.deprecated_at,
      inserted_at: plan.inserted_at,
      updated_at: plan.updated_at }
  end
end
