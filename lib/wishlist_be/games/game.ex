defmodule WishlistBe.Games.Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    field :name, :string
    field :steam_id, :string

    many_to_many :wishlists, YourApp.Wishlists.Wishlist, join_through: "wishlists_games"
    has_many :priorities, WishlistBe.Priorities.Priority

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:name, :steam_id])
    |> validate_required([:name, :steam_id])
    |> unique_constraint(:steam_id)
  end
end
