defmodule EventsWeb.CommentController do
  use EventsWeb, :controller

  alias Events.Comments
  alias Events.Comments.Comment
  alias Events.CalEvents
  plug EventsWeb.Plugs.RequireUser

  def create(conn, %{"comment" => comment_params}) do
    cal_event = comment_params["event_id"]
                |> CalEvents.get_cal_event!
                |> CalEvents.preload_cal_event
    if !(current_user_is?(conn, cal_event.owner) || current_user_in?(conn, cal_event.invites)) do
      conn
      |> put_flash(:error, "Comment creation error")
      |> redirect(to: Routes.cal_event_path(conn, :show, cal_event))
    else
      comment_params = Map.put(comment_params, "user_id", current_user_id(conn))
      case Comments.create_comment(comment_params) do
        {:ok, comment} ->
          conn
          |> put_flash(:info, "Comment created successfully.")
          |> redirect(to: Routes.cal_event_path(conn, :show, cal_event))

        {:error, %Ecto.Changeset{} = changeset} ->
          conn
          |> put_flash(:error, "Comment creation error")
          |> redirect(to: Routes.cal_event_path(conn, :show, cal_event))
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Comments.get_comment!(id)
    cal_event = comment.event_id
                |> CalEvents.get_cal_event!
    if !(current_user_is?(conn, cal_event.owner) || current_user_is?(conn, comment.user_id)) do
      conn
      |> put_flash(:error, "Comment creation error")
      |> redirect(to: Routes.cal_event_path(conn, :show, cal_event))
    else
      {:ok, comment} = Comments.delete_comment(comment)
      conn
      |> put_flash(:info, "Comment deleted successfully.")
      |> redirect(to: Routes.cal_event_path(conn, :show, comment.event_id))
    end
  end
end
