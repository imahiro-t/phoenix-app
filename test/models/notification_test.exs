defmodule Notify.NotificationTest do
  use Notify.ModelCase

  alias Notify.Notification

  @valid_attrs %{action_date: %{day: 17, month: 4, year: 2010}, action_time: %{hour: 14, min: 0, sec: 0}, notify_before: 42, notify_date_time: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, sent: true, subject: "some content", summary: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Notification.changeset(%Notification{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Notification.changeset(%Notification{}, @invalid_attrs)
    refute changeset.valid?
  end
end
