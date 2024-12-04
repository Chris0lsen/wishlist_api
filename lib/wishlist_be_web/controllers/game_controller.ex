defmodule WishlistBeWeb.GameController do
  use WishlistBeWeb, :controller
  alias WishlistBe.Games

  action_fallback WishlistBeWeb.FallbackController

  def get_by_wishlist_id(conn, %{"wishlist_id" => wishlist_id}) do
    games = Games.list_games_for_wishlist(wishlist_id)
    render(conn, "index.json", games: games)
  end
end
