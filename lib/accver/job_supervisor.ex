defmodule Accver.JobSupervisor do
  alias Accver.SyncJob
  use Supervisor

  # Client-API
  def start_link(opts\\[name: __MODULE__, restart: :transient]) do
    Task.Supervisor.start_link(opts)
  end

  def start_job(account, :simwms) do
    __MODULE__ |> Task.Supervisor.start_child(SyncJob, :update, [account])
  end

  def start_job(account) do
    __MODULE__ |> Task.Supervisor.start_child(SyncJob, :sync, [account])
  end

  def start_job(account, pid) do
    __MODULE__ |> Task.Supervisor.start_child(SyncJob, :sync_callback, [account, pid])
  end

  # Server
  def init(x), do: x
end