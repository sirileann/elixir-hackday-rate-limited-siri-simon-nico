defmodule RateLimitedWeb.PingController do
  use RateLimitedWeb, :controller

  def pong(conn, params) do
    IO.inspect(params)
    text(conn, "ok")
  end
end
