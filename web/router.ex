defmodule Core.Router do
  use Core.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  scope "/", Core do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", Core do
    pipe_through :api
    # post "/sessions", SessionController, :create
    # delete "/sessions", SessionController, :delete
    resources "/sessions", SessionController, only: [:create, :delete], singleton: true
    resources "/sessions", SessionController, only: [:delete]
    
    resources "/users", UserController, only: [:create]
    resources "/accounts", AccountController, only: [:create, :delete, :update, :index, :show]
  end
end
