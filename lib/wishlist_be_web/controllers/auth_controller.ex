defmodule WishlistBeWeb.AuthController do
  use WishlistBeWeb, :controller
  alias WishlistBe.Steam
  alias WishlistBe.UserSession

  def request(conn, _params) do
    redirect_url = Steam.generate_openid_redirect_url()
    redirect(conn, external: redirect_url)
  end

  def callback(conn, params) do
    case Steam.verify_openid_response(params) do
      {:ok, user_info} ->
        session_token = Ecto.UUID.generate()
        UserSession.store_user_session(session_token, user_info)
        # Set the session token as a cookie or return it in the response
        conn
        |> put_resp_cookie("session_token", session_token, http_only: true)
        |> redirect(external: Steam.frontend_redirect_url(user_info))
      {:error, reason} ->
        conn
        |> put_flash(:error, "Authentication failed: #{reason}")
        |> redirect(external: Steam.frontend_redirect_url())
    end
  end
end
