defmodule SkynetWeb.TerminatorController do
  use SkynetWeb, :controller

  alias Skynet.GenServer.Terminator
  alias Skynet.Supervisors.TerminatorSupervisor

  action_fallback SkynetWeb.FallbackController

  def index(conn, _params) do
    terminators = TerminatorSupervisor.terminator_list()
    render(conn, :index, terminators: terminators)
  end

  def create(conn, _params) do
    with {:ok, pid} <- TerminatorSupervisor.create_terminator(),
        id when not is_nil(id) <- Terminator.get_id(pid) do
          conn
          |> put_status(:created)
          |> render(:show, terminator: %{id: id})
    else
      _ -> {:error, :unprocessable_entity}
    end
  end

  def delete(conn, %{"id" => _id}) do
    conn
  end
end
