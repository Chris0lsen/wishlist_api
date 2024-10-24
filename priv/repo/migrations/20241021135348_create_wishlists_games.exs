defmodule WishlistBe.Repo.Migrations.CreateWishlistsGames do
  use Ecto.Migration

  def change do
    create table(:wishlists_games) do
      add :wishlist_id, references(:wishlists, on_delete: :delete_all), null: false
      add :game_id, references(:games, on_delete: :delete_all), null: false

      timestamps()
    end

    create unique_index(:wishlists_games, [:wishlist_id, :game_id])
  end
end
