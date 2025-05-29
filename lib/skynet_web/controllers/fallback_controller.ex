defmodule SkynetWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use SkynetWeb, :controller

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    render_error(conn, :not_found, :"404")
  end

  # This clause to handle resources that can't be created
  def call(conn, {:error, :unprocessable_entity}) do
    render_error(conn, :unprocessable_entity, :"422")
  end

  defp render_error(conn, status, code) do
    conn
    |> put_status(status)
    |> put_view(html: SkynetWeb.ErrorHTML, json: SkynetWeb.ErrorJSON)
    |> render(code)
  end
end
