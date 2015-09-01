defmodule Core.PaymentSubscriptionController do
  use Core.Web, :controller
  alias Core.PaymentSubscription
  alias Core.ServicePlan

  plug :scrub_params, "payment_subscription" when action in [:update]
  plug Core.Plugs.Session, :reject_not_logged_in_users when action in [:delete, :update]

  def show(conn, %{"id" => id}) do
    subscription = PaymentSubscription |> Repo.get!(id) |> Repo.preload([:service_plan, account: :user])
    render(conn, "show.json", payment_subscription: subscription)
  end

  def delete(conn, %{"id" => id}) do
    subscription = PaymentSubscription |> Repo.get!(id)
    |> reset_to_free_trial!
    |> PaymentSubscription.cancel_stripe!
    render(conn, "show.json", payment_subscription: subscription)
  end

  def update(conn, %{"id" => id, "payment_subscription" => params}) do
    subscription = PaymentSubscription |> Repo.get!(id)
    changeset = PaymentSubscription.changeset(subscription, params)
    source = params["source"]
    if changeset.valid? do
      subscription = changeset
      |> Repo.update!
      |> Repo.preload([:service_plan, account: :user])
      |> PaymentSubscription.synchronize_stripe!(source)
      render(conn, "show.json", payment_subscription: subscription)
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render(Core.ChangesetView, "error.json", changeset: changeset)
    end
  end

  defp reset_to_free_trial!(subscription) do
    params = %{ service_plan_id: ServicePlan.free_trial.id }
    subscription
    |> PaymentSubscription.changeset(params)
    |> Repo.update!
    |> Repo.preload([:service_plan, account: :user])
  end
end