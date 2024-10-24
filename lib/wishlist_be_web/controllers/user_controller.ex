defmodule WishlistBeWeb.UserController do
  use WishlistBeWeb, :controller

  alias WishlistBe.UserSession

  def groups_and_wishlists(conn, _params) do
    with ["Bearer " <> session_token] <- get_req_header(conn, "authorization"),
         {:ok, user_data} <- UserSession.get_user_session(session_token) do
      json(conn, %{groups: user_data.groups, wishlists: user_data.wishlists})
    else
      _ -> send_resp(conn, :unauthorized, "Invalid session")
    end
  end
end
