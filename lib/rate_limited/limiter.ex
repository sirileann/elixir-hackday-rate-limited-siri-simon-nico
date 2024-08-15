defmodule Limiter do
  use GenServer

  @impl true
  def init(blocked) do
    blocked = false
  end

  @impl true
  def handle_call(:block, _from, _state) do
    blocked = true
    {:reply, blocked, blocked}
  end

  @impl true
  def handle_call(:check_state, _from, _state) do
    {:reply, blocked, _state}
  end
end
