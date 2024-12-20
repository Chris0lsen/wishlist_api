defmodule WishlistBe.Repo.Migrations.RemoveTimestampsFromUsersGroups do
  use Ecto.Migration

  def change do
    alter table(:users_groups) do
      remove :inserted_at
      remove :updated_at
    end
  end
end
