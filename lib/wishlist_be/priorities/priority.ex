defmodule WishlistBe.Priorities.Priority do
  use Ecto.Schema
  import Ecto.Changeset

  schema "priorities" do
    field :priority, :integer

    belongs_to :user, YourApp.Accounts.User
    belongs_to :game, YourApp.Games.Game
    belongs_to :wishlist, YourApp.Wishlists.Wishlist

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(priority, attrs) do
    priority
    |> cast(attrs, [:priority])
    |> validate_required([:priority])
  end
end
