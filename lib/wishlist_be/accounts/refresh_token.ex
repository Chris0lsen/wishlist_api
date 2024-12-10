defmodule WishlistBe.Accounts.RefreshToken do
  use Ecto.Schema
  import Ecto.Changeset

  schema "refresh_tokens" do
    field :token, :string
    field :expires_at, :utc_datetime
    field :revoked, :boolean, default: false

    belongs_to :user, WishlistBe.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(refresh_token, attrs) do
    refresh_token
    |> cast(attrs, [:token, :expires_at, :revoked, :user_id])
    |> validate_required([:token, :expires_at, :user_id])
    |> unique_constraint(:token)
  end
end
