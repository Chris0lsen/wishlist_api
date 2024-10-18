defmodule WishlistBe.Repo do
  use Ecto.Repo,
    otp_app: :wishlist_be,
    adapter: Ecto.Adapters.Postgres
end
