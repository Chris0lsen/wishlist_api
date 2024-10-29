defmodule WishlistBeWeb.WishlistController do
  use WishlistBeWeb, :controller

  def index(conn, %{"user_id" => user_id}) do
    # Get JWT out of conn
  end
end
