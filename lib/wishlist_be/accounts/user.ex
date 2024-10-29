defmodule WishlistBe.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :email, :string
    field :steam_id, :string

    many_to_many :groups, WishlistBe.Groups.Group, join_through: "users_groups"
    has_many :priorities, WishlistBe.Priorities.Priority
    has_many :refresh_tokens, WishlistBe.Accounts.RefreshToken

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :steam_id])
    |> validate_required([:steam_id])
    |> unique_constraint(:email)
    |> unique_constraint(:steam_id)
  end
end
