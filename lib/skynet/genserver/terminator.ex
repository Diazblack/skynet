defmodule Skynet.GenServer.Terminator do
  use GenServer

  @name __MODULE__

  @combat_timer Application.compile_env(:skynet, Terminator)[:combat_timer]
  @spawn_timer Application.compile_env(:skynet, Terminator)[:spawn_timer]

  alias Skynet.Supervisors.TerminatorSupervisor
  def start_link(opts \\ []) do
    GenServer.start_link(@name, opts, name: register_name(opts))
  end

  def register_name( [name: name]), do: {:via, Registry, {Skynet.CyborgRegistry, name}}
  def register_name(_opts), do: {:via, Registry, {Skynet.CyborgRegistry, generate_unique_name()}}

  @impl true
  def init(opts) do
    Process.send_after(self(), :ready, 1)
    {:ok, opts}
  end

  def child_spec(opts) do
    %{
      id: @name,
      start: {@name, :start_link, [opts]},
      restart: :transient,
      type: :worker
    }
  end

  @impl true
  def handle_info(:ready, state) do
    send_after(:combat, @combat_timer)
    send_after(:spawn, @spawn_timer)
    {:noreply, state}
  end

  @impl true
  def handle_cast(:combat, state) do
    if :rand.uniform() <= 0.25 do # equal to 25%
      {:stop, :killed_by_sarah_connor, state}
      else
        send_after(:combat, @combat_timer)
      {:noreply, state}
    end
  end

  @impl true
  def handle_cast(:spawn, state) do
    if :rand.uniform() <= 0.20 do # equal to 20%
      TerminatorSupervisor.create_terminator()
    end
    send_after(:spawn, @spawn_timer)
    {:noreply, state}
  end

  def get_spawn_timeout, do: @spawn_timer
  def get_combat_timeout, do: @combat_timer

  def generate_unique_name(),  do: "T1000-#{Ecto.UUID.generate()}"
  def send_after(message, timeout), do:  Process.send_after(self(), {:cast, message}, timeout)
end
