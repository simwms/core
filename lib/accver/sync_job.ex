defmodule Accver.SyncJob do

  def update(%{id: id}) do
    Core.Account
    |> Core.Repo.get!(id)
    |> Core.SimwmsSynchronizer.synchronize
  end
  
  def sync(%{id: id}) do
    Core.Account
    |> Core.Repo.get!(id)
    |> Core.AccountSynchronizer.synchronize!
  end

  def sync_callback(%{id: id}=account, pid) do
    pid |> send({:try, id})
    sync(account)
    pid |> send({:done, id})
  end
end