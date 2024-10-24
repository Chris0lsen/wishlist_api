defmodule WishlistBe.Application do
  use Application

  def start(_type, _args) do
    children = [
      WishlistBeWeb.Telemetry,
      WishlistBe.Repo,
      {DNSCluster, query: Application.get_env(:wishlist_be, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: WishlistBe.PubSub},
      {Finch, name: WishlistBe.Finch},
      WishlistBeWeb.Endpoint,
      # Start the user session GenServer
      WishlistBe.UserSession
    ]

    opts = [strategy: :one_for_one, name: WishlistBe.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    WishlistBeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
