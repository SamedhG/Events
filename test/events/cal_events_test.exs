defmodule Events.CalEventsTest do
  use Events.DataCase

  alias Events.CalEvents

  describe "events" do
    alias Events.CalEvents.CalEvent

    @valid_attrs %{description: "some description", title: "some title", when: "2010-04-17T14:00:00Z"}
    @update_attrs %{description: "some updated description", title: "some updated title", when: "2011-05-18T15:01:01Z"}
    @invalid_attrs %{description: nil, title: nil, when: nil}

    def cal_event_fixture(attrs \\ %{}) do
      {:ok, cal_event} =
        attrs
        |> Enum.into(@valid_attrs)
        |> CalEvents.create_cal_event()

      cal_event
    end

    test "list_events/0 returns all events" do
      cal_event = cal_event_fixture()
      assert CalEvents.list_events() == [cal_event]
    end

    test "get_cal_event!/1 returns the cal_event with given id" do
      cal_event = cal_event_fixture()
      assert CalEvents.get_cal_event!(cal_event.id) == cal_event
    end

    test "create_cal_event/1 with valid data creates a cal_event" do
      assert {:ok, %CalEvent{} = cal_event} = CalEvents.create_cal_event(@valid_attrs)
      assert cal_event.description == "some description"
      assert cal_event.title == "some title"
      assert cal_event.when == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
    end

    test "create_cal_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CalEvents.create_cal_event(@invalid_attrs)
    end

    test "update_cal_event/2 with valid data updates the cal_event" do
      cal_event = cal_event_fixture()
      assert {:ok, %CalEvent{} = cal_event} = CalEvents.update_cal_event(cal_event, @update_attrs)
      assert cal_event.description == "some updated description"
      assert cal_event.title == "some updated title"
      assert cal_event.when == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
    end

    test "update_cal_event/2 with invalid data returns error changeset" do
      cal_event = cal_event_fixture()
      assert {:error, %Ecto.Changeset{}} = CalEvents.update_cal_event(cal_event, @invalid_attrs)
      assert cal_event == CalEvents.get_cal_event!(cal_event.id)
    end

    test "delete_cal_event/1 deletes the cal_event" do
      cal_event = cal_event_fixture()
      assert {:ok, %CalEvent{}} = CalEvents.delete_cal_event(cal_event)
      assert_raise Ecto.NoResultsError, fn -> CalEvents.get_cal_event!(cal_event.id) end
    end

    test "change_cal_event/1 returns a cal_event changeset" do
      cal_event = cal_event_fixture()
      assert %Ecto.Changeset{} = CalEvents.change_cal_event(cal_event)
    end
  end
end
