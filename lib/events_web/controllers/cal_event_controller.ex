defmodule EventsWeb.CalEventController do
  use EventsWeb, :controller

  alias Events.CalEvents
  alias Events.CalEvents.CalEvent
  alias Events.Comments.Comment

  alias EventsWeb.Plugs

  plug Plugs.RequireUser when action in [:new, :create, :edit, :update, :delete]
  plug :fetch_event when action in [:show, :photo, :edit, :update, :delete]
  plug :require_owner when action in [:edit, :update, :delete]

  def fetch_event(conn, _args) do
    id = conn.params["id"]
    event = CalEvents.get_cal_event!(id)
    assign(conn, :event, event)
  end

  def require_owner(conn, _args) do
    user = conn.assigns[:current_user]
    event = conn.assigns[:event]

    if user.id == event.owner do
      conn
    else
      conn
      |> put_flash(:error, "That isn't yours.")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end


  def index(conn, _params) do
    events = CalEvents.list_events()
    render(conn, "index.html", events: events)
  end

  def new(conn, _params) do
    changeset = CalEvents.change_cal_event(%CalEvent{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"cal_event" => cal_event_params}) do
    cal_event_params = cal_event_params |> Map.put("owner", conn.assigns[:current_user].id)
    case CalEvents.create_cal_event(cal_event_params) do
      {:ok, cal_event} ->
        conn
        |> put_flash(:info, "Cal event created successfully.")
        |> redirect(to: Routes.cal_event_path(conn, :show, cal_event))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    cal_event = id
                |> CalEvents.get_cal_event!
                |> CalEvents.preload_cal_event
    new_comment = Events.Comments.change_comment(%Comment{
      event_id: id, 
      user_id: current_user_id(conn)
    })
    render(conn, "show.html", cal_event: cal_event, new_comment: new_comment)
  end

  def edit(conn, %{"id" => id}) do
    cal_event = CalEvents.get_cal_event!(id)
    changeset = CalEvents.change_cal_event(cal_event)
    render(conn, "edit.html", cal_event: cal_event, changeset: changeset)
  end

  def update(conn, %{"id" => id, "cal_event" => cal_event_params}) do
    cal_event = CalEvents.get_cal_event!(id)

    case CalEvents.update_cal_event(cal_event, cal_event_params) do
      {:ok, cal_event} ->
        conn
        |> put_flash(:info, "Cal event updated successfully.")
        |> redirect(to: Routes.cal_event_path(conn, :show, cal_event))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", cal_event: cal_event, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    cal_event = CalEvents.get_cal_event!(id)
    {:ok, _cal_event} = CalEvents.delete_cal_event(cal_event)

    conn
    |> put_flash(:info, "Cal event deleted successfully.")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
