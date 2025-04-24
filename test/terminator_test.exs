defmodule Skynet.TerminatorTest do
  use ExUnit.Case, async: true

  alias Skynet.GenServer.Terminator

  describe "start_link/0" do
    test "spawns successfully" do
      assert {:ok, pid} = Terminator.start_link()
      assert is_pid(pid)
      assert Process.alive?(pid)
    end
  end

  describe "hnadle_info/2" do
    setup do
      Application.put_env(:skynet, Terminator, [combat_timer: 10, spawn_timer: 10])
      {:ok, pid} = start_supervised({Terminator, []})
      %{pid: pid}
    end

    test "sending :ready schedules :combat and :replicate", %{pid: pid} do
      send(pid, :ready)
      Process.sleep(100)
      assert_receive {:gen_cast, :combat}, 50
      assert_receive {:gen_cast, :replicate}, 50
    end
  end
end
