# Adapted from class code
defmodule EventsWeb.Plugs.FetchSession do
  import Plug.Conn

  def init(args), do: args

  def call(conn, _args) do
    user = Events.Users.get_user(get_session(conn, :user_id) || -1)
    if user do
      token = Phoenix.Token.sign(conn, "user_id", user.id)
      conn
      |> assign(:current_user, user)
      |> assign(:user_token, token)
    else
      assign(conn, :current_user, nil)
    end
  end
end
