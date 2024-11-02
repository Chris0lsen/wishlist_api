defmodule WishlistBeWeb.GroupController do
  use WishlistBeWeb, :controller
  alias WishlistBe.Groups
  def index(_conn, %{"user_id" => user_id}) do
    # List groups for user
    case Groups.list_groups_for_user(user_id) do
      groups when is_list(groups) ->
        groups
      error -> %{"Error" => "Error: #{inspect(error)}"}
    end
  end
end
