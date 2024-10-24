defmodule WishlistBe.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string, null: false, unique: true

      timestamps()
    end
  end
end
