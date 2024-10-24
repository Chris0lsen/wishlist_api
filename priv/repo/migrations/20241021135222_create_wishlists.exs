defmodule WishlistBe.Repo.Migrations.CreateWishlists do
  use Ecto.Migration

  def change do
    create table(:wishlists) do
      add :name, :string, null: false
      add :group_id, references(:groups, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:wishlists, [:group_id])
  end
end
