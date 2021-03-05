defmodule Events.CalEvents.CalEvent do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :description, :string, null: false, default: ""
    field :title, :string, null: false
    field :date, :date, null: false
    field :time, :time, null: false

    timestamps()
  end

  @doc false
  def changeset(cal_event, attrs) do
    cal_event
    |> cast(attrs, [:title, :description, :time, :date])
    |> validate_required([:title, :description, :time, :date])
  end
end
