defmodule Events.Photos do
  @moduledoc """
  The Photos context.
  """

  import Ecto.Query, warn: false
  alias Events.Repo

  alias Events.Photos.Photo


  def get_photo!(id), do: Repo.get!(Photo, id)


  def save_photo(path, type) do
    data = File.read!(path)
    hash = sha256(data)
    attrs = Repo.get_by(Photo, [hash: hash])
    if attrs == nil do
      attrs = %{
        hash: hash,
        type: type,
        refs: 1
      }
      File.mkdir_p!(base_path(hash))
      File.write!(photo_path(hash), data)
      %Photo{}
      |> Photo.changeset(attrs)
      |> Repo.insert()
    else
      Repo.update(Photo.changeset(attrs, %{refs: attrs.refs + 1}))
    end
  end

  def load_photo(id) do
    if id == nil do
      data = File.read!(Path.expand("priv/photo/default.png"))
      {:ok, data, "image/png"}
    else
      photo = get_photo!(id)
      data = File.read!(photo_path(photo.hash))
      {:ok, data, photo.type}
    end
  end

  def base_path(hash) do
    Path.expand("~/.local/data/events")
    |> Path.join(String.slice(hash, 0, 2))
  end

  def photo_path(hash) do
    Path.join(base_path(hash), String.slice(hash, 2, 30))
  end

  def sha256(data) do
    :crypto.hash(:sha256, data)
    |> Base.encode16(case: :lower)
  end

end
