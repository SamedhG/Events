defmodule EventsWeb.CalEventController do
  use EventsWeb, :controller

  alias Events.CalEvents
  alias Events.CalEvents.CalEvent

  def index(conn, _params) do
    events = CalEvents.list_events()
    render(conn, "index.html", events: events)
  end

  def new(conn, _params) do
    changeset = CalEvents.change_cal_event(%CalEvent{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"cal_event" => cal_event_params}) do
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
    cal_event = CalEvents.get_cal_event!(id)
    render(conn, "show.html", cal_event: cal_event)
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
    |> redirect(to: Routes.cal_event_path(conn, :index))
  end
end
