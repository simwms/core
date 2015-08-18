defmodule Core.Router do
  use Core.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
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
    
    resources "/sessions", SessionController, only: [:create, :delete], singleton: true
    resources "/sessions", SessionController, only: [:delete]
    resources "/service_plans", ServicePlanController, only: [:index, :show]
    resources "/users", UserController, only: [:create]
    resources "/accounts", AccountController, only: [:create, :delete, :update, :index, :show]
    resources "/payment_subscriptions", PaymentSubscriptionController, only: [:update, :delete]
  end
end
