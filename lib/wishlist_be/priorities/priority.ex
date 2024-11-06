defmodule WishlistBe.Priorities.Priority do
  use Ecto.Schema
  import Ecto.Changeset

  schema "priorities" do
    field :priority, :integer

    belongs_to :user, WishlistBe.Accounts.User
    belongs_to :game, WishlistBe.Games.Game
    belongs_to :wishlist, WishlistBe.Wishlists.Wishlist

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(priority, attrs) do
    priority
    |> cast(attrs, [:priority])
    |> validate_required([:priority])
  end
end
