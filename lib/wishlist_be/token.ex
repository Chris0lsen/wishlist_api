defmodule WishlistBe.Token do
  use Joken.Config
  alias WishlistBe.Repo
  alias WishlistBe.Accounts.RefreshToken

  @issuer "wishlist_be"

  # Function to fetch the secret key from configuration or environment variable
  defp secret_key do
    Application.fetch_env!(:wishlist_be, WishlistBe.Token)[:secret_key]
  end

  # Define a function to return the signer
  def signer do
    Joken.Signer.create("HS256", secret_key())
  end

  @impl true
  def token_config do
    default_claims(iss: @issuer, default_exp: 3600)
    |> add_claim("user_id", nil, &(&1 != nil))
    |> add_claim("steam_id", nil, &(&1 != nil))
  end

  def generate_refresh_token(user) do
    token = :crypto.strong_rand_bytes(64) |> Base.url_encode64()
    # 30 days
    expires_at = DateTime.add(DateTime.utc_now(), 60 * 60 * 24 * 30, :second)

    %RefreshToken{}
    |> RefreshToken.changeset(%{
      token: token,
      user_id: user.id,
      expires_at: expires_at
    })
    |> Repo.insert()
    |> case do
      {:ok, refresh_token} -> {:ok, refresh_token.token}
      error -> error
    end
  end
end
