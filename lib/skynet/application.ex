defmodule Skynet.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SkynetWeb.Telemetry,
      Skynet.Repo,
      {DNSCluster, query: Application.get_env(:skynet, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Skynet.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Skynet.Finch},
      # Start a worker by calling: Skynet.Worker.start_link(arg)
      # {Skynet.Worker, arg},
      # Start to serve requests, typically the last entry
      SkynetWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Skynet.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SkynetWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
