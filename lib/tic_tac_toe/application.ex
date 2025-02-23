defmodule TicTacToe.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TicTacToeWeb.Telemetry,
      TicTacToe.Repo,
      {DNSCluster, query: Application.get_env(:tic_tac_toe, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: TicTacToe.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: TicTacToe.Finch},
      # Start a worker by calling: TicTacToe.Worker.start_link(arg)
      # {TicTacToe.Worker, arg},
      # Start to serve requests, typically the last entry
      TicTacToeWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TicTacToe.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TicTacToeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
