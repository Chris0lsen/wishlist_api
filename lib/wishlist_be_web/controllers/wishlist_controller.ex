defmodule WishlistBeWeb.WishlistController do
  use WishlistBeWeb, :controller
  alias WishlistBe.Wishlists
  def index(_conn, %{"user_id" => user_id}) do
    # List wishlists for user
    case Wishlists.list_wishlists_for_user(user_id) do
      wishlists when is_list(wishlists) ->
        wishlists
      _ -> %{"Error" => "error"}
    end

  end
end
