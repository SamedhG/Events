defmodule Events.Repo.Migrations.CreatePhotos do
  use Ecto.Migration

  def change do
    create table(:photos) do
      add :hash, :text, null: false, unique: true
      add :refs, :integer, null: false
      add :type, :string, null: false
      timestamps()
    end

  end
end
