defmodule WishlistBe.Repo.Migrations.CreatePriorities do
  use Ecto.Migration

  def change do
    create table(:priorities) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :game_id, references(:games, on_delete: :delete_all), null: false
      add :wishlist_id, references(:wishlists, on_delete: :delete_all), null: false
      add :priority, :integer, null: false

      timestamps()
    end

    create unique_index(:priorities, [:user_id, :wishlist_id, :game_id])
  end
end
