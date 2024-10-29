defmodule WishlistBe.Repo.Migrations.AddSteamIdToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :steam_id, :string, null: false
    end

    create unique_index(:users, [:steam_id])
  end
end
