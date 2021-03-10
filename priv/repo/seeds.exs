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


alice = Repo.insert!(%User{name: "alice", email: "a@b.com"})
bob = Repo.insert!(%User{name: "bob", email: "c@d.com"})

p = %CalEvent{
  title: "Smash Bros",
  description: "Open tournament",
  date: Date.new!(2020, 01, 02),
  time: Time.new!(1,2,3),
  owner: alice.id
}
Repo.insert!(p)

p = %CalEvent{
  title: "Skiing",
  description: "On the mountains",
  date: Date.new!(2020, 01, 03),
  time: Time.new!(2,3,4),
  owner: alice.id
}
Repo.insert!(p)

p = %CalEvent{
  title: "Dinner",
  description: "Steak",
  date: Date.new!(2020, 01, 04),
  time: Time.new!(3,4,5),
  owner: bob.id
}
Repo.insert!(p)
