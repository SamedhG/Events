defmodule Events.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :title, :string, null: false
      add :description, :text, null: false, default: ""
      add :date, :date, null: false 
      add :time, :time, null: false
      add :owner, references(:users), null: false
      timestamps()
    end

  end
end
