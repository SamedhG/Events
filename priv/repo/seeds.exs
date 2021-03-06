# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Events.Repo.insert!(%Events.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
#

alias Events.Repo
alias Events.Users.User
alias Events.CalEvents.CalEvent
alias Events.Invites.Invite
alias Events.Comments.Comment
alias Events.Photos

defmodule Inject do
  def photo(name, type) do
    photos = Application.app_dir(:events, "priv/photo")
    path = Path.join(photos, name)
    {:ok, photo}  = Photos.save_photo(path, "type")
    photo
  end
end

p1 = Inject.photo("alice.png", "image/png")
p2 = Inject.photo("bob.jpg", "image/jpg")

alice = Repo.insert!(%User{name: "alice", email: "a@b.com", photo_id: p1.id})
bob = Repo.insert!(%User{name: "bob", email: "c@d.com", photo_id: p2.id})

e1 = %CalEvent{
  title: "Smash Bros",
  description: "Open tournament",
  date: Date.new!(2020, 01, 02),
  time: Time.new!(1,2,3),
  owner: alice.id
}
e1 = Repo.insert!(e1)

e2 = %CalEvent{
  title: "Skiing",
  description: "On the mountains",
  date: Date.new!(2020, 01, 03),
  time: Time.new!(2,3,4),
  owner: alice.id
}
_e2 = Repo.insert!(e2)

e3 = %CalEvent{
  title: "Dinner",
  description: "Steak",
  date: Date.new!(2020, 01, 04),
  time: Time.new!(3,4,5),
  owner: bob.id
}
e3 = Repo.insert!(e3)

# Alice invites Bob for SSBU
i1 = %Invite{
  email: "c@d.com",
  event_id: e1.id,
  response: "maybe",
}
Repo.insert!(i1)

# Alice invites non-existent user 
i2 = %Invite{
  email: "e@f.com",
  event_id: e1.id,
  response: "maybe",
}
Repo.insert!(i2)


# Bob invite alice for Dinner
i3 = %Invite{
  email: "a@b.com",
  event_id: e3.id,
  response: "maybe",
}
Repo.insert!(i3)

# Bob invites non-existent user 
i4 = %Invite{
  email: "e@f.com",
  event_id: e3.id,
  response: "maybe",
}
Repo.insert!(i4)

Repo.insert(%Comment{
  user_id: alice.id,
  event_id: e1.id,
  body: "Dibs on Pikachu"
})

Repo.insert(%Comment{
  user_id: bob.id,
  event_id: e1.id,
  body: "Will there be pizza?"
})

Repo.insert(%Comment{
  user_id: alice.id,
  event_id: e1.id,
  body: "@bob yes"
})
