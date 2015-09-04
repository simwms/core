defmodule Core.AccountController do
  use Core.Web, :controller

  alias Core.Account
  alias Core.Session
  alias Core.AccountQuery
  plug :scrub_params, "account" when action in [:create, :update]
  plug Core.Plugs.Session, :reject_not_logged_in_users when action in [:create, :index]

  def index(conn, params) do
    current_user = conn |> Session.current_user
    accounts = {current_user, params}
    |> AccountQuery.index
    |> Repo.all
    |> Repo.preload(AccountQuery.preload_fields)
    render(conn, "index.json", accounts: accounts)
  end

  def create(conn, %{"account" => account_params}) do
    changeset = conn 
    |> Session.current_user
    |> build(:accounts)
    |> Account.createset(account_params)

    if changeset.valid? do
      account = changeset |> Repo.insert!
      account |> Accver.synchronize
      conn
      |> render("show.json", account: account)
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render(Core.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    account = Repo.get!(Account, id) |> Repo.preload(AccountQuery.preload_fields)
    render conn, "show.json", account: account
  end

  def update(conn, %{"id" => id, "account" => account_params}) do
    account = Repo.get!(Account, id)
    changeset = Account.changeset(account, account_params)

    if changeset.valid? do
      account = Repo.update!(changeset) |> Repo.preload(AccountQuery.preload_fields)
      render(conn, "show.json", account: account)
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render(Core.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    account = Repo.get!(Account, id)

    account = Repo.delete!(account)
    render(conn, "show.json", account: account)
  end
end
