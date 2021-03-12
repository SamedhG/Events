defmodule EventsWeb.InviteController do
  use EventsWeb, :controller

  alias Events.Invites
  alias Events.Invites.Invite
  alias Events.CalEvents
  action_fallback EventsWeb.FallbackController

  
  def index(conn, _params) do
    invites = Invites.list_invites()
    render(conn, "index.json", invites: invites)
  end

  def create(conn, %{"event_id" => event_id, "email" => email}) do
    owner = CalEvents.get_cal_event!(event_id).owner
    curr_id = conn.assigns[:current_user].id
    # Check user id in token
    invite_params = %{
      event_id: event_id, 
      email: email, 
      response: "maybe"
    }
    with {:ok, %Invite{} = invite} <- Invites.create_invite(invite_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.invite_path(conn, :show, invite))
      |> render("show.json", invite: invite)
    end
  end

  def show(conn, %{"id" => id}) do
    invite = Invites.get_invite!(id)
    render(conn, "show.json", invite: invite)
  end

  def update(conn, %{"event_id" => event_id, "response" => response}) do
    curr_email = conn.assigns[:current_user].email
    invite = event_id
             |> CalEvents.get_cal_event!
             |> CalEvents.preload_cal_event
             |> Map.get(:invites)
             |> Enum.find(nil, &(&1.email == curr_email))
    invite_params = %{response: response}
    with {:ok, %Invite{} = invite} <- Invites.update_invite(invite, invite_params) do
      render(conn, "show.json", invite: invite)
    end
  end

  def delete(conn, %{"id" => id}) do
    invite = Invites.get_invite!(id)

    with {:ok, %Invite{}} <- Invites.delete_invite(invite) do
      send_resp(conn, :no_content, "")
    end
  end
end
