defmodule Skynet.Supervisors.TerminatorSupervisor do
  use DynamicSupervisor

  @name __MODULE__

  alias Skynet.GenServer.Terminator

  def start_link(opts) do
    DynamicSupervisor.start_link(@name, opts, name: @name)
  end

  @impl true
  def init(_opts) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def create_terminator(supervisor \\ @name, registry \\ Skynet.CyborgRegistry) do
    spec = Terminator.child_spec(supervisor: supervisor, registry: registry)
    DynamicSupervisor.start_child(@name, spec)
  end

  def kill_terminator(id, supervisor \\ @name, registry \\ Skynet.CyborgRegistry) do
    pid = Terminator.get_pid(id, registry)
    DynamicSupervisor.terminate_child(supervisor, pid)
  end

  def terminator_list(registry \\ Skynet.CyborgRegistry) do
    Registry.select(registry, [
      {
        {:"$1", :"$2", :"$3"},
        [],
        [%{id: :"$1", pid: :"$2", value: :"$3"}]
      }
    ])
  end
end
