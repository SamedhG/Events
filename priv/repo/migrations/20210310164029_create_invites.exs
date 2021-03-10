defmodule Events.Repo.Migrations.CreateInvites do
  use Ecto.Migration

  def change do
    create table(:invites) do
      add :email, :string, null: false
      add :response, :string, null: false, default: "maybe"
      add :event_id, references(:events, on_delete: :nothing), null: false
      timestamps()
    end

    create index(:invites, [:event_id])
    create index(:invites, [:email, :event_id], unique: true)
  end
end
