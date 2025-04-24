defmodule Skynet.TerminatorSupervisorTest do
  use ExUnit.Case, async: true

  alias Skynet.Supervisors.TerminatorSupervisor

  setup do
    [supervisor_pid: Process.whereis(TerminatorSupervisor)]
  end

  describe "create_terminator" do
    test "Should create a new Terminator" do

       assert {:ok, t_pid} = TerminatorSupervisor.create_terminator()
       assert Process.alive?(t_pid)
    end

    test "Should create multiple Terminator with unique ids" do
      assert {:ok, t1_pid} = TerminatorSupervisor.create_terminator()
      assert {:ok, t2_pid} = TerminatorSupervisor.create_terminator()

      assert 2 == Registry.count(Skynet.CyborgRegistry)
      assert Process.alive?(t1_pid)
      assert Process.alive?(t2_pid)
      refute t1_pid == t2_pid
    end
  end
end
