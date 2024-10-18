defmodule WishlistBeWeb.AuthController do
  use WishlistBeWeb, :controller
  alias WishlistBe.Steam

  def request(conn, _params) do
    redirect_url = Steam.generate_openid_redirect_url()
    redirect(conn, external: redirect_url)
  end

  def callback(conn, params) do
    case Steam.verify_openid_response(params) do
      {:ok, steam_id} ->
        json(conn, %{steam_id: steam_id})

      {:error, reason} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: reason})
    end
  end
end
