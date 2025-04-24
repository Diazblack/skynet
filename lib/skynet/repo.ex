defmodule Skynet.Repo do
  use Ecto.Repo,
    otp_app: :skynet,
    adapter: Ecto.Adapters.Postgres
end
