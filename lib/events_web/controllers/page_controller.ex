defmodule EventsWeb.PageController do
  use EventsWeb, :controller
  
  alias Events.CalEvents
  def index(conn, _params) do
    current_user = conn.assigns[:current_user]
    if current_user != nil do
      events = CalEvents.list_events()
      |> Enum.filter(&(&1.owner == current_user.id))
      render(conn, "index.html", events: events)
    else
      render(conn, "index.html")
    end
  end
end
