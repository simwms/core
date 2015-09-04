defmodule Core.StripeSynchronizer do
  alias Core.AccountQuery
  alias Core.Repo
  alias Core.PaymentSubscription

  def synchronize(account) do
    account |> PaymentSubscription.free_trial
    account |> Repo.preload(AccountQuery.preload_fields)
  end
  
end
