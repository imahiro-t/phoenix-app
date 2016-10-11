defmodule Notify.Router do
  use Notify.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Notify do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/notify", NotifyController, except: [:show]
  end

  # Other scopes may use custom stacks.
  # scope "/api", Notify do
  #   pipe_through :api
  # end
end
