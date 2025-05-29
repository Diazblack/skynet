defmodule SkynetWeb.TerminatorControllerTest do
  use SkynetWeb.ConnCase

  # alias Skynet.GenServer.Terminator
  alias Skynet.Supervisors.TerminatorSupervisor

  setup %{conn: conn} do
    pid = Process.whereis(TerminatorSupervisor)
    assert {:ok, t1_pid} = TerminatorSupervisor.create_terminator()
    assert {:ok, t2_pid} = TerminatorSupervisor.create_terminator()
    assert {:ok, t3_pid} = TerminatorSupervisor.create_terminator()
    assert {:ok, t4_pid} = TerminatorSupervisor.create_terminator()
    on_exit(fn -> DynamicSupervisor.stop(pid, :normal)  end)

    [
      conn: put_req_header(conn, "accept", "application/json"),
      supervisor_id: pid,
      terminator_ids: [t1_pid, t2_pid, t3_pid, t4_pid]
    ]
  end

  describe "index" do
    test "lists all terminators", %{conn: conn} do
      response =
        conn
        |> get(~p"/api/v1/terminators")
        |> json_response(200)

      assert response["data"] |> length() == 4
    end
  end

  describe "create terminator" do
    test "renders terminator when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/v1/terminators")
      assert %{"id" => _id} = json_response(conn, 201)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, supervisor_id: pid } do
      DynamicSupervisor.stop(pid, :normal)
      Process.sleep(500)
      conn = post(conn, ~p"/api/v1/terminators")
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  # describe "delete terminator" do
  #   test "deletes chosen terminator", %{conn: conn} do
  #     conn = delete(conn, ~p"/api/v1/terminators/#{terminator}")
  #     assert response(conn, 204)

  #     assert_error_sent 404, fn ->
  #       get(conn, ~p"/api/v1/terminators/#{terminator}")
  #     end
  #   end
  # end
end
