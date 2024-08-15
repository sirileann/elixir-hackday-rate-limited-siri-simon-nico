defmodule RateLimitedWeb.PingController do
  use RateLimitedWeb, :controller

  def pong(conn, _params) do
    ip = conn.remote_ip |> :inet.ntoa() |> to_string()
    is_blocked = Limiter.block(ip)

    if is_blocked do
      conn
      |> put_status(429)
      |> json(%{error: "Too many requests. Please try again later. ---> YOU ARE BLOCKED!!!!11!!11!!!"})
    else
      conn
      |> put_status(200)
      |> json("all good, we like you :) ")
    end
  end
end
