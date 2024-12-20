defmodule WishlistBe.Wishlists.Wishlist do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:name]}
  schema "wishlists" do
    field :name, :string

    belongs_to :group, WishlistBe.Groups.Group

    many_to_many :games, WishlistBe.Games.Game, join_through: WishlistBe.WishlistsGames.WishlistGame
    has_many :priorities, WishlistBe.Priorities.Priority

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(wishlist, attrs) do
    wishlist
    |> cast(attrs, [:name, :group_id])
    |> validate_required([:name, :group_id])
  end
end
