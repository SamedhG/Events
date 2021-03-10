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


alice = Repo.insert!(%User{name: "alice", email: "a@b.com"})
bob = Repo.insert!(%User{name: "bob", email: "c@d.com"})

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
e2 = Repo.insert!(e2)

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
