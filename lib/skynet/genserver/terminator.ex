defmodule Skynet.GenServer.Terminator do
  use GenServer

  @name __MODULE__
  @registry Skynet.CyborgRegistry
  @combat_timer Application.compile_env(:skynet, Terminator)[:combat_timer]
  @spawn_timer Application.compile_env(:skynet, Terminator)[:spawn_timer]

  alias Skynet.Supervisors.TerminatorSupervisor

  require Logger
  def start_link([supervisor: _supervisor, registry: registry] = opts) do
    id = generate_id(opts)
    registration_name = {:via, Registry, {registry, id}}

    GenServer.start_link(@name, [{:id, id} | opts], name: registration_name)
  end

  def child_spec(opts) do
    %{
      id: nil,
      start: {@name, :start_link, [opts]},
      # if killed don't restart
      restart: :temporary
    }
  end

  def generate_id([id: id]), do: id
  def generate_id(_opts), do: generate_unique_name()

  def get_pid(id, registry \\ @registry ) do
    [{pid, _ } | _] = Registry.lookup(registry, id)
    pid
  end

  def get_id(pid) do
    GenServer.call(pid, :get_id)
  end

  @impl true
  def init([id: id, supervisor: _, registry: _] = opts) do
    Logger.info("Initiating Terminator #{id}")
    send_after(:ready, 1)
    {:ok, opts}
  end

  @impl true
  def handle_info(:ready, state) do
    send_after(:combat, @combat_timer)
    send_after(:spawn, @spawn_timer)
    {:noreply, state}
  end

  @impl true
  def handle_info(:combat, state) do
    Logger.info("Terminator #{state[:id]}, encounter with human forces")
    if :rand.uniform() <= 0.25 do # equal to 25%
      {:stop, :killed_by_sarah_connor, state}
      else
        send_after(:combat, @combat_timer)
      {:noreply, state}
    end
  end

  @impl true
  def handle_info(:spawn, state) do
    if :rand.uniform() <= 0.20 do # equal to 20%
      TerminatorSupervisor.create_terminator()
      Logger.info("Terminator #{state[:id]}, replication process completed")
    end
    send_after(:spawn, @spawn_timer)
    {:noreply, state}
  end

  @impl true
  def handle_call(:get_id, _from, [{:id, id} | _tail] = state) do
    {:reply, id, state}
  end

  @impl true
  def terminate(:kill_command, [{:id, id} | _tails]) do
    Logger.info("Terminator #{id}, initiating self destruct sequence ")
    :shotdown
  end

  @impl true
  def terminate(:killed_by_sarah_connor, [{:id, id} | _tails]) do
    Logger.info("Terminator #{id}, was killed by Sarah Connor")
    :shotdown
  end


  def get_spawn_timeout, do: @spawn_timer
  def get_combat_timeout, do: @combat_timer

  def generate_unique_name(),  do: "T1000-#{Ecto.UUID.generate()}"
  def send_after(message, timeout), do:  Process.send_after(self(), message, timeout)
end
