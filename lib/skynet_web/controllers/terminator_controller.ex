defmodule SkynetWeb.TerminatorController do
  use SkynetWeb, :controller

  alias Skynet.Supervisors.TerminatorSupervisor

  action_fallback SkynetWeb.FallbackController

  def index(conn, _params) do
    terminators = TerminatorSupervisor.terminator_list()
    render(conn, :index, terminators: terminators)
  end

  def create(conn, _params) do
    conn
  end

  def delete(conn, %{"id" => id}) do
    conn
  end
end
