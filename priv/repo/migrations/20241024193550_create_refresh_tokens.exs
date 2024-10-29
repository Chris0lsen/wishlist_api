defmodule MyApp.Repo.Migrations.CreateRefreshTokens do
  use Ecto.Migration

  def change do
    create table(:refresh_tokens) do
      add :token, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :expires_at, :utc_datetime, null: false
      add :revoked, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:refresh_tokens, [:token])
    create index(:refresh_tokens, [:user_id])
  end
end
