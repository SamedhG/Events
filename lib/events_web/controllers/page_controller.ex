defmodule EventsWeb.PageController do
  use EventsWeb, :controller
  
  alias Events.CalEvents
  def index(conn, _params) do
    current_user = conn.assigns[:current_user]
    if current_user != nil do
      loaded_user = Events.Users.preload_user(current_user)
      conn = assign(conn, :current_user, loaded_user) 
      render(conn, "index.html")
    else
      render(conn, "index.html")
    end
  end
end
