defmodule Limiter do
  use GenServer

  # Client API

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)  # Registering the GenServer by module name
  end

  def block do
    GenServer.call(__MODULE__, :block)
  end

  def check_state do
    GenServer.call(__MODULE__, :check_state)
  end


  # Server (GenServer) callbacks

  @impl true
  def init(_state) do
    state = %{blocked: false, counter: 0}
    IO.inspect("Limiter started")
    {:ok, state}
  end

  @impl true
  def handle_call(:block, _from, state) do
    if state.counter < 3, do:
      new_counter = state.counter + 1

      new_blocked = if new_counter > 3, do: true, else: false

      new_state = %{state | counter: new_counter, blocked: new_blocked}
      IO.inspect(new_state, label: "New State after possible block")
      Process.send_after(self(), :handle_blocked, 10000)
      {:reply, new_blocked, new_state}
    end
    {:reply, state.blocked, state}
  end

  @impl true
  def handle_call(:check_state, _from, state) do
    {:reply, state.blocked, state}
  end

  @impl true
  def handle_info(:handle_blocked, state) do
    new_counter = state.counter - 1
    new_state = %{state | counter: new_counter}
    IO.inspect(new_state, label: "New State after 10s")
    {:noreply, new_state}
  end
end
