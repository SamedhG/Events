defmodule EventsWeb.UserController do
  use EventsWeb, :controller

  alias Events.Users
  alias Events.Users.User
  alias Events.Photos

  alias EventsWeb.Plugs

  plug Plugs.RequireUser when action in [:edit, :update]
  plug :require_owner when action in [:edit, :update]

  def require_owner(conn, _args) do
    {id, _} = Integer.parse(conn.params["id"])
    if current_user_is?(conn, id) do
      conn
    else
      conn
      |> put_flash(:error, "That isn't yours.")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end



  def index(conn, _params) do
    users = Users.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Users.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    user_params = add_photo_to_user(user_params)
    case Users.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> EventsWeb.SessionController.create(%{"email" => user.email, "redirect_to" => user_params["redirect_to"]})
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    changeset = Users.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)

    case Users.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end


  def photo(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    {:ok, data, type} = Photos.load_photo(user.photo_id)
    conn
    |> put_resp_content_type(type)
    |> send_resp(200, data)
  end


  defp add_photo_to_user(user_params) do
    up = user_params["photo"]
    if up == nil do
      user_params
    else
      # TODO: check if the type is a valid image type?
      {:ok, photo} = Photos.save_photo(up.path, up.content_type)
      Map.put user_params, "photo_id", photo.id
    end
  end

end
