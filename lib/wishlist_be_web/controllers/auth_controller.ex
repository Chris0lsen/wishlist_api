defmodule WishlistBeWeb.AuthController do
  use WishlistBeWeb, :controller
  alias WishlistBe.Steam

  def request(conn, _params) do
    redirect_url = Steam.generate_openid_redirect_url()
    redirect(conn, external: redirect_url)
  end

  def callback(conn, params) do
    case WishlistBe.Steam.verify_openid_response(params) do
      {:ok, steam_id} ->
        # Redirect to the frontend with the steam_id as a query parameter
        redirect(conn, external: frontend_redirect_url(steam_id))

      {:error, reason} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: reason})
    end
  end

  defp frontend_redirect_url(steam_id) do
    # URL to your frontend with steam_id as a query parameter
    "http://192.168.68.90:5173/auth/steam/callback?steam_id=#{steam_id}"
  end
end
