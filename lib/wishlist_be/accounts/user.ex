defmodule WishlistBe.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :email, :string
    field :steam_id, :string

    many_to_many :groups, WishlistBe.Groups.Group, join_through: "users_groups"
    has_many :priorities, WishlistBe.Priorities.Priority
    has_many :refresh_tokens, MyApp.Accounts.RefreshToken

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
    |> unique_constraint(:email)
  end
end
