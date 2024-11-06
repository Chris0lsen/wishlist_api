defmodule WishlistBeWeb.GroupController do
  use WishlistBeWeb, :controller
  alias WishlistBe.Groups

  action_fallback WishlistBeWeb.FallbackController

  def index(conn, params) do
    user_id = params["user_id"]
    groups = Groups.list_groups_for_user(user_id, preload_wishlists: true)
    render(conn, "index.json", groups: groups)
  end

  def show(conn, %{"id" => id}) do
    with {:ok, group} <- Groups.get_group(id) do
      render(conn, "show.json", group: group)
    end
  end
end
