defmodule Events.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :name, :string

    belongs_to :photo, Events.Photos.Photo
    has_many :events, Events.CalEvents.CalEvent, foreign_key: :owner
    has_many :invites, Events.Invites.Invite, foreign_key: :email, references: :email
    has_many :comments, Events.Comments.Comment
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :photo_id])
    |> validate_required([:name, :email])
    |> unique_constraint(:email)
  end


end
