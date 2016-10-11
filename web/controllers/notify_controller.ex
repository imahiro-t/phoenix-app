defmodule Notify.NotifyController do
  use Notify.Web, :controller

  alias Notify.Notification

  def index(conn, _params) do
    changeset = Notification.changeset(%Notification{})
    conn
    |> assign(:notifications_sent_not_yet, notifications_sent_not_yet)
    |> assign(:notifications_sent, notifications_sent)
    |> assign(:changeset, changeset)
    |> assign(:title, "登録画面")
    |> render("index.html")
  end

  def create(conn, %{"notification" => notification_params}) do
    changeset = Notification.changeset(%Notification{}, notification_params |> modify_action_time)

    case Repo.insert(changeset) do
      {:ok, notification} ->
        notify_date_time = get_notify_date_time(notification)
        notification
        |> Ecto.Changeset.change(%{notify_date_time: notify_date_time})
        |> Repo.update!
        conn
        |> put_flash(:info, "[#{notification.subject}]を作成しました")
        |> redirect(to: notify_path(conn, :index))
      {:error, changeset} ->
        conn
        |> assign(:notifications_sent_not_yet, notifications_sent_not_yet)
        |> assign(:notifications_sent, notifications_sent)
        |> assign(:changeset, changeset)
        |> assign(:title, "登録画面")
        |> render("index.html")
    end
  end

  def edit(conn, %{"id" => id}) do
    notification = Repo.get!(Notification, id)
    changeset = Notification.changeset(notification)
    conn
    |> assign(:notification, notification)
    |> assign(:changeset, changeset)
    |> assign(:title, "編集画面")
    |> render("edit.html")
  end

  def update(conn, %{"id" => id, "notification" => notification_params}) do
    notification = Repo.get!(Notification, id)
    changeset = Notification.changeset(notification, notification_params |> modify_action_time)

    case Repo.update(changeset) do
      {:ok, notification} ->
        notify_date_time = get_notify_date_time(notification)
        notification
        |> Ecto.Changeset.change(%{notify_date_time: notify_date_time, sent: false})
        |> Repo.update!
        conn
        |> put_flash(:info, "[#{notification.subject}]を更新しました")
        |> redirect(to: notify_path(conn, :index))
      {:error, changeset} ->
        conn
        |> assign(:notification, notification)
        |> assign(:changeset, changeset)
        |> assign(:title, "編集画面")
        |> render("edit.html")
    end
  end

  def delete(conn, %{"id" => id}) do
    notification = Repo.get!(Notification, id)

    Repo.delete!(notification)
    conn
    |> put_flash(:info, "[#{notification.subject}]を削除しました")
    |> redirect(to: notify_path(conn, :index))
  end

  defp modify_action_time(params) do
    r = ~r/^\d{2}:\d{2}$/
    %{params | "action_time" => Regex.replace(r, params["action_time"], "\\0" <> ":00")}
  end

  defp notifications_sent_not_yet do
    Notification
    |> where([u], u.sent == false)
    |> Repo.all
  end

  defp notifications_sent do
    Notification
    |> where([u], u.sent == true)
    |> Repo.all
  end

  defp get_notify_date_time(notification) do
    Ecto.DateTime.from_date_and_time(notification.action_date, notification.action_time)
    |> add_minutes(-(notification.notify_before))
  end

  defp add_minutes(date_time, minutes) do
    date_time
    |> Ecto.DateTime.to_erl
    |> :calendar.datetime_to_gregorian_seconds
    |> Kernel.+(60 * minutes)
    |> :calendar.gregorian_seconds_to_datetime
    |> :calendar.local_time_to_universal_time_dst
    |> hd
    |> Ecto.DateTime.from_erl
  end
end
