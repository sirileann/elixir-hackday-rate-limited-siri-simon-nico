defmodule RateLimitedWeb.PingController do
  use RateLimitedWeb, :controller

  def pong(conn, params) do
    IO.inspect(params)
    Limiter.block
    text(conn, Limiter.check_state)
  end
end
