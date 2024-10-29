defmodule WishlistBe.Wishlists.Wishlist do
  use Ecto.Schema
  import Ecto.Changeset

  schema "wishlists" do
    field :name, :string
    field :group_id, :id

    many_to_many :games, WishlistBe.Games.Game, join_through: "wishlists_games"
    has_many :priorities, WishlistBe.Priorities.Priority

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(wishlist, attrs) do
    wishlist
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
