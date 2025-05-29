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
end
