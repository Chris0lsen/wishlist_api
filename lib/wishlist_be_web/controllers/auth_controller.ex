defmodule WishlistBeWeb.AuthController do
  use WishlistBeWeb, :controller
  alias WishlistBe.Steam
  alias WishlistBe.Accounts
  alias WishlistBe.Token

  def request(conn, _params) do
    redirect_url = Steam.generate_openid_redirect_url()
    redirect(conn, external: redirect_url)
  end

  def callback(conn, params) do
    with {:ok, steam_id} <- Steam.verify_openid_response(params),
         {:ok, user} <- Accounts.get_or_create_user_by_steam_id(steam_id),
         custom_claims = %{"user_id" => user.id, "steam_id" => steam_id},
         {:ok, access_token, _claims} <- Token.generate_and_sign(custom_claims, Token.signer()),
         {:ok, refresh_token} <- Accounts.generate_refresh_token(user) do
      conn
      |> put_resp_cookie("refresh_token", refresh_token,
        http_only: true,
        secure: true,
        max_age: 60 * 60 * 24 * 30
      )
      |> redirect(external: frontend_redirect_url(access_token))
    else
      {:error, reason} ->
        error_message = URI.encode("Authentication failed: #{inspect(reason)}")
        redirect_url = frontend_redirect_url(nil) <> "?error=#{error_message}"

        conn
        |> redirect(external: redirect_url)
    end
  end

  def refresh(conn, %{"refresh_token" => refresh_token}) do
    with {:ok, user} <- Accounts.verify_refresh_token(refresh_token),
         custom_claims = %{"user_id" => user.id, "steam_id" => user.steam_id},
         {:ok, access_token, _claims} <- Token.generate_and_sign(custom_claims),
         {:ok, new_refresh_token} <- Accounts.generate_refresh_token(user),
         {:ok, _} <- Accounts.revoke_refresh_token(refresh_token) do
      json(conn, %{
        "access_token" => access_token,
        "refresh_token" => new_refresh_token
      })
    else
      _ ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid refresh token"})
    end
  end

  defp frontend_redirect_url(access_token) do
    url = Steam.get_config_url(:frontend)
    query_params = if access_token, do: %{token: access_token}, else: %{}
    query = URI.encode_query(query_params)
    URI.to_string(%{url | query: query})
  end
end
