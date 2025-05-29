defmodule Skynet.TerminatorTest do
  use ExUnit.Case, async: true

  alias Skynet.GenServer.Terminator
  alias Skynet.Supervisors.TerminatorSupervisor

  setup_all do
    pid = Process.whereis(TerminatorSupervisor)
    start_supervised!({Registry, keys: :unique, name: FakeRegistryTest })
    [supervisor_pid: pid, registry: FakeRegistryTest]
  end

  describe "start_link/1" do
    test "spawns successfully", %{supervisor_pid: pid, registry: reg} do
      assert {:ok, pid} = Terminator.start_link([supervisor: pid, registry: reg])
      assert is_pid(pid)
      assert Process.alive?(pid)
    end
  end

  describe "handle_info/2" do
    test "sending :ready schedules :combat and :spawn", %{supervisor_pid: pid, registry: reg}  do
      Application.put_env(:skynet, Terminator, [combat_timer: 10, spawn_timer: 10])
      {:ok, pid} = start_supervised({Terminator, [supervisor: pid, registry: reg]})
      [pid: pid]
      send(pid, :ready)
      Process.sleep(100)
      assert_receive :combat, 50
      assert_receive :gen_info, :spawn, 50
    end
  end
end
