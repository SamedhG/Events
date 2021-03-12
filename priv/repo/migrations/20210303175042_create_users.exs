defmodule Events.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
      add :email, :string, null: false
      add :photo_id, references(:photos)
      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
