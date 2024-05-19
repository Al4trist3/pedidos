defmodule Pedidos.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PedidosWeb.Telemetry,
      Pedidos.Repo,
      {DNSCluster, query: Application.get_env(:pedidos, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Pedidos.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Pedidos.Finch},
      # Start a worker by calling: Pedidos.Worker.start_link(arg)
      # {Pedidos.Worker, arg},
      # Start to serve requests, typically the last entry
      PedidosWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Pedidos.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PedidosWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
