defmodule WishlistBeWeb.WishlistController do
  use WishlistBeWeb, :controller
  alias WishlistBe.Wishlists

  action_fallback WishlistBeWeb.FallbackController

  def index(conn, params) do
    user_id = params["user_id"]
    wishlists = Wishlists.list_wishlists_for_user_by_group(user_id)
    render(conn, "index.json", wishlists: wishlists)
  end

  def show(conn, %{"id" => id}) do
    with {:ok, wishlist} <- Wishlists.get_wishlist(id) do
      render(conn, "show.json", wishlist: wishlist)
    end
  end
  def add_by_steam_id(conn, %{"wishlist_id" => wishlist_id, "steam_id" => steam_id}) do
    case Wishlists.add_game_to_wishlist_by_steam_id(wishlist_id, steam_id) do
      {:ok, wishlist} -> json(conn, wishlist)
      {:error, error} -> json(conn, %{"Error" => "Error: #{inspect(error)}"})
    end
  end
end
