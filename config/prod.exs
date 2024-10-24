import Config

# Configures Swoosh API Client
config :swoosh, api_client: Swoosh.ApiClient.Finch, finch_name: WishlistBe.Finch

# Disable Swoosh Local Memory Storage
config :swoosh, local: false

# Do not print debug messages in production
config :logger, level: :info

# Runtime production configuration, including reading
# of environment variables, is done on config/runtime.exs.
config :wishlist_be, :urls,
  frontend: [
    scheme: System.get_env("FRONTEND_SCHEME") || "https",
    host: System.get_env("FRONTEND_HOST") || "your-production-domain.com",
    port: System.get_env("FRONTEND_PORT") |> String.to_integer() || 443,
    path: "/auth/steam/callback"
  ],
  backend: [
    scheme: System.get_env("BACKEND_SCHEME") || "https",
    host: System.get_env("BACKEND_HOST") || "your-backend-domain.com",
    port: System.get_env("BACKEND_PORT") |> String.to_integer() || 443,
    path: "/api/auth/steam/return"
  ]
