defmodule WishlistBe.Groups.Group do
  use Ecto.Schema
  import Ecto.Changeset

  schema "groups" do
    field :name, :string

    many_to_many :users, WishlistBe.Accounts.User, join_through: "users_groups"
    has_many :wishlists, WishlistBe.Wishlists.Wishlist

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(group, attrs) do
    group
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
