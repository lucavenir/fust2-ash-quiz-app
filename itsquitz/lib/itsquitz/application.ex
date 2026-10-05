defmodule Itsquitz.Application do
  # See https://elixir.hexdocs.pm/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ItsquitzWeb.Telemetry,
      Itsquitz.Repo,
      {DNSCluster, query: Application.get_env(:itsquitz, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Itsquitz.PubSub},
      # Start a worker by calling: Itsquitz.Worker.start_link(arg)
      # {Itsquitz.Worker, arg},
      # Start to serve requests, typically the last entry
      ItsquitzWeb.Endpoint
    ]

    # See https://elixir.hexdocs.pm/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Itsquitz.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ItsquitzWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
