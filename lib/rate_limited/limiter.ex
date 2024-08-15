defmodule Limiter do
  use GenServer

  # Constants
  @const_time 10000

  @const_threshold 5

  # Client API

  def start_link(_) do
    # Registering the GenServer by module name
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def block(caller_ip) do
    GenServer.call(__MODULE__, {:block, caller_ip})
  end

  def check_state(caller_ip) do
    GenServer.call(__MODULE__, {:check_state, caller_ip})
  end

  # Server (GenServer) callbacks
  @impl true
  def init(_args) do
    {:ok, %{}}
  end

  @impl true
  def handle_call({:block, caller_ip}, _from, state) do
    counter = Map.get(state, caller_ip, 0)

    {new_counter, is_blocked} =
      if counter < @const_threshold do
        Process.send_after(self(), {:handle_blocked, caller_ip}, @const_time)
        {counter + 1, false}
      else
        {counter, true}
      end

    new_state = Map.put(state, caller_ip, new_counter)
    IO.inspect(new_state, label: "New State after possible block")
    {:reply, is_blocked, new_state}
  end

  @impl true
  def handle_call({:check_state, caller_ip}, _from, state) do
    counter = Map.get(state, caller_ip, 0)
    {:reply, counter > @const_threshold, state}
  end

  @impl true
  def handle_info({:handle_blocked, caller_ip}, state) do
    counter = Map.get(state, caller_ip, 0)

    new_state = Map.put(state, caller_ip, counter - 1)

    IO.inspect(new_state, label: "New State after 10s")

    {:noreply, new_state}
  end
end
