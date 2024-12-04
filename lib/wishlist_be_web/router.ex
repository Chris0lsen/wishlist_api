defmodule WishlistBeWeb.Router do
  use WishlistBeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug WishlistBeWeb.Plugs.AuthPlug
  end

  scope "/api", WishlistBeWeb do
    pipe_through :api

    get "/auth/steam", AuthController, :request
    get "/auth/steam/return", AuthController, :callback
    post "/auth/refresh", AuthController, :refresh

    get "/steam/search", SteamController, :search
  end

  scope "/api", WishlistBeWeb do
    pipe_through [:api, :auth]

    get "/steam/wishlist", SteamController, :wishlist

    get "/wishlists/:user_id/wishlists", WishlistController, :index
    get "/wishlists/:wishlist_id", WishlistController, :get
    post "/wishlists/:wishlist_id/games/steam/:steam_id", WishlistController, :add_by_steam_id

    get "/wishlists/:wishlist_id/games", GameController, :get_by_wishlist_id

    get "/users/:user_id/groups", GroupController, :index
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:wishlist_be, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: WishlistBeWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
