defmodule Events.CalEvents do
  @moduledoc """
  The CalEvents context.
  """

  import Ecto.Query, warn: false
  alias Events.Repo

  alias Events.CalEvents.CalEvent

  @doc """
  Returns the list of events.

  ## Examples

      iex> list_events()
      [%CalEvent{}, ...]

  """
  def list_events do
    Repo.all(CalEvent)
  end

  @doc """
  Gets a single cal_event.

  Raises `Ecto.NoResultsError` if the Cal event does not exist.

  ## Examples

      iex> get_cal_event!(123)
      %CalEvent{}

      iex> get_cal_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_cal_event!(id), do: Repo.get!(CalEvent, id)

  @doc """
  Creates a cal_event.

  ## Examples

      iex> create_cal_event(%{field: value})
      {:ok, %CalEvent{}}

      iex> create_cal_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_cal_event(attrs \\ %{}) do
    %CalEvent{}
    |> CalEvent.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a cal_event.

  ## Examples

      iex> update_cal_event(cal_event, %{field: new_value})
      {:ok, %CalEvent{}}

      iex> update_cal_event(cal_event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_cal_event(%CalEvent{} = cal_event, attrs) do
    cal_event
    |> CalEvent.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a cal_event.

  ## Examples

      iex> delete_cal_event(cal_event)
      {:ok, %CalEvent{}}

      iex> delete_cal_event(cal_event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_cal_event(%CalEvent{} = cal_event) do
    Repo.delete(cal_event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking cal_event changes.

  ## Examples

      iex> change_cal_event(cal_event)
      %Ecto.Changeset{data: %CalEvent{}}

  """
  def change_cal_event(%CalEvent{} = cal_event, attrs \\ %{}) do
    CalEvent.changeset(cal_event, attrs)
  end

  def preload_cal_event(%CalEvent{} = event), do: Repo.preload(event, [:user, :invites, comments: [:user]])
end
