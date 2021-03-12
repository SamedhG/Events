defmodule Events.CalEvents.CalEvent do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :description, :string
    field :title, :string
    field :date, :date
    field :time, :time
    field :num_yes, :integer, virtual: true, default: 0
    field :num_no, :integer, virtual: true, default: 0
    field :num_maybe, :integer, virtual: true, default: 0
    belongs_to :user, Events.Users.User, foreign_key: :owner
    has_many :invites, Events.Invites.Invite, foreign_key: :event_id 
    has_many :comments, Events.Comments.Comment, foreign_key: :event_id
    timestamps()
  end

  @doc false
  def changeset(cal_event, attrs) do
    cal_event
    |> cast(attrs, [:title, :description, :time, :date, :owner])
    |> validate_required([:title, :description, :time, :date, :owner])
  end
end
