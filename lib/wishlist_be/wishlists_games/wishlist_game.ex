defmodule WishlistBe.WishlistsGames.WishlistGame do
  use Ecto.Schema
  import Ecto.Changeset

  schema "wishlists_games" do
    belongs_to :game, WishlistBe.Games.Game
    belongs_to :wishlist, WishlistBe.Wishlists.Wishlist

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(wishlist_game, attrs) do
    wishlist_game
    |> cast(attrs, [])
    |> validate_required([])
  end
end
