defmodule Core.ServicePlanController do
  use Core.Web, :controller

  alias Core.ServicePlan
  alias Core.ServicePlanQuery
  
  plug :scrub_params, "service_plan" when action in [:create, :update]

  def index(conn, params) do
    service_plans = params |> ServicePlanQuery.index |> Repo.all
    render(conn, "index.json", service_plans: service_plans)
  end

  def show(conn, %{"id" => id}) do
    service_plan = Repo.get!(ServicePlan, id)
    render conn, "show.json", service_plan: service_plan
  end

  # def create(conn, %{"service_plan" => service_plan_params}) do
  #   changeset = ServicePlan.changeset(%ServicePlan{}, service_plan_params)

  #   if changeset.valid? do
  #     service_plan = Repo.insert!(changeset)
  #     render(conn, "show.json", service_plan: service_plan)
  #   else
  #     conn
  #     |> put_status(:unprocessable_entity)
  #     |> render(Core.ChangesetView, "error.json", changeset: changeset)
  #   end
  # end


  # def update(conn, %{"id" => id, "service_plan" => service_plan_params}) do
  #   service_plan = Repo.get!(ServicePlan, id)
  #   changeset = ServicePlan.changeset(service_plan, service_plan_params)

  #   if changeset.valid? do
  #     service_plan = Repo.update!(changeset)
  #     render(conn, "show.json", service_plan: service_plan)
  #   else
  #     conn
  #     |> put_status(:unprocessable_entity)
  #     |> render(Core.ChangesetView, "error.json", changeset: changeset)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   service_plan = Repo.get!(ServicePlan, id)

  #   service_plan = Repo.delete!(service_plan)
  #   render(conn, "show.json", service_plan: service_plan)
  # end
end
