defmodule EventsWeb.CalEventControllerTest do
  use EventsWeb.ConnCase

  alias Events.CalEvents

  @create_attrs %{description: "some description", title: "some title", when: "2010-04-17T14:00:00Z"}
  @update_attrs %{description: "some updated description", title: "some updated title", when: "2011-05-18T15:01:01Z"}
  @invalid_attrs %{description: nil, title: nil, when: nil}

  def fixture(:cal_event) do
    {:ok, cal_event} = CalEvents.create_cal_event(@create_attrs)
    cal_event
  end

  describe "index" do
    test "lists all events", %{conn: conn} do
      conn = get(conn, Routes.cal_event_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Events"
    end
  end

  describe "new cal_event" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.cal_event_path(conn, :new))
      assert html_response(conn, 200) =~ "New Cal event"
    end
  end

  describe "create cal_event" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.cal_event_path(conn, :create), cal_event: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.cal_event_path(conn, :show, id)

      conn = get(conn, Routes.cal_event_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Cal event"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.cal_event_path(conn, :create), cal_event: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Cal event"
    end
  end

  describe "edit cal_event" do
    setup [:create_cal_event]

    test "renders form for editing chosen cal_event", %{conn: conn, cal_event: cal_event} do
      conn = get(conn, Routes.cal_event_path(conn, :edit, cal_event))
      assert html_response(conn, 200) =~ "Edit Cal event"
    end
  end

  describe "update cal_event" do
    setup [:create_cal_event]

    test "redirects when data is valid", %{conn: conn, cal_event: cal_event} do
      conn = put(conn, Routes.cal_event_path(conn, :update, cal_event), cal_event: @update_attrs)
      assert redirected_to(conn) == Routes.cal_event_path(conn, :show, cal_event)

      conn = get(conn, Routes.cal_event_path(conn, :show, cal_event))
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, cal_event: cal_event} do
      conn = put(conn, Routes.cal_event_path(conn, :update, cal_event), cal_event: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Cal event"
    end
  end

  describe "delete cal_event" do
    setup [:create_cal_event]

    test "deletes chosen cal_event", %{conn: conn, cal_event: cal_event} do
      conn = delete(conn, Routes.cal_event_path(conn, :delete, cal_event))
      assert redirected_to(conn) == Routes.cal_event_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.cal_event_path(conn, :show, cal_event))
      end
    end
  end

  defp create_cal_event(_) do
    cal_event = fixture(:cal_event)
    %{cal_event: cal_event}
  end
end
