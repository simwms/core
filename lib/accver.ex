defmodule Accver do
  @moduledoc """
  A portmanteau of Account and Server, this module provides an application
  which communicates with Amazon, Stripe, and Simwms to help complete all
  the fields in an account model.
  """

  def synchronize(account, :simwms) do
    Accver.JobSupervisor.start_job(account, :simwms)
  end

  def synchronize(account) do
    Accver.JobSupervisor.start_job(account)
  end

  def synchronize(account, pid) do
    Accver.JobSupervisor.start_job(account, pid)
  end

end