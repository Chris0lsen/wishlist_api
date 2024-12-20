# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :wishlist_be,
  ecto_repos: [WishlistBe.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :wishlist_be, WishlistBeWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: WishlistBeWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: WishlistBe.PubSub,
  live_view: [signing_salt: "SwLexfKM"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :wishlist_be, WishlistBe.Mailer, adapter: Swoosh.Adapters.Local

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# config/config.exs

config :wishlist_be, :urls,
  frontend: [
    scheme: "http",
    host: System.get_env("FRONTEND_HOST") || "localhost",
    port: String.to_integer(System.get_env("FRONTEND_PORT") || "5173"),
    path: "/auth/steam/callback"
  ],
  backend: [
    scheme: "http",
    host: System.get_env("BACKEND_HOST") || "localhost",
    port: String.to_integer(System.get_env("BACKEND_PORT") || "4000"),
    path: "/api/auth/steam/return"
  ]


  config :wishlist_be, WishlistBe.Guardian,
  issuer: "wishlist_be",
  secret_key: System.get_env("JWT_SECRET_KEY")


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
