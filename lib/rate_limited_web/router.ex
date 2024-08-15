defmodule RateLimitedWeb.Router do
  use RateLimitedWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  # pipeline :api do
  #   plug :accepts, ["html"]
  #   plug :fetch_session
  #   plug :protect_from_forgery
  #   plug :put_secure_browser_headers
  # end

  scope "/api", RateLimitedWeb do
    pipe_through :api

    get "/ping", PingController, :pong
  end
end
