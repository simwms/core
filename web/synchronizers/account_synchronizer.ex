defmodule Core.AccountSynchronizer do
  @max_sync_attempts 10
  
  def synchronize!(account) do
    if not(account |> synchronized?) and (account |> attemptable?) do
      sync!(account)
    else
      account 
    end
  end

  defp sync!(account) do
    account
    |> Core.Account.increment_attempt!
    |> ensure_amazon
    |> ensure_stripe
    |> ensure_simwms
  end

  def ensure_amazon(account) do
    if account |> amazon?, do: account, else: account |> amazon!
  end

  def ensure_stripe(account) do
    if account |> stripe?, do: account, else: account |> stripe!
  end

  def ensure_simwms(account) do
    if account |> simwms?, do: account, else: account |> simwms!
  end

  def attemptable?(%{setup_attempts: n}), do: n < @max_sync_attempts
  def attemptable?(_), do: false

  def synchronized?(%{is_properly_setup: true}), do: true
  def synchronized?(_), do: false

  def amazon!(account), do: account |> Core.AmazonSynchronizer.synchronize
  def amazon?(%{access_key_id: aid, secret_access_key: sak}) when is_binary(aid) and is_binary(sak) do
    true
  end
  def amazon?(_), do: false

  def stripe!(account), do: account |> Core.StripeSynchronizer.synchronize
  def stripe?(account) do
    case account |> Core.Account.get_service_plan do
      nil -> false
      _plan -> true
    end
  end

  def simwms!(account), do: account |> Core.SimwmsSynchronizer.synchronize
  def simwms?(%{simwms_account_key: sak}) when is_binary(sak) do
    true
  end
  def simwms?(_), do: false
end