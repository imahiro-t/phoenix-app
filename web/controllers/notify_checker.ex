defmodule Notify.NotifyChecker do
  import Ecto.Query

  alias Notify.Repo
  alias Notify.Notification
  alias Notify.Mailer
  alias Notify.Email

  def check_notify do
    for n <- notifications_to_send do
      send_mail n
      update_table n
    end
  end

  defp notifications_to_send do
    Notification
    |> where([u], u.sent == false and u.notify_date_time <= from_now(0, "microsecond"))
    |> Repo.all
  end

  defp send_mail(notification) do
    notification
    |> Email.notify_mail
    |> Mailer.deliver_now
  end

  defp update_table(notification) do
    notification
    |> Ecto.Changeset.change(%{sent: true})
    |> Repo.update!
  end
end

defmodule Notify.Email do
  import Bamboo.Email

  def notify_mail(notification) do
    new_email
    |> to(Application.get_env(:notify, :mail_to))
    |> from(Application.get_env(:notify, :mail_from))
    |> subject("【通知】 #{notification.subject}")
    |> text_body(notification |> notify_body)
  end

  defp notify_body(notification) do
    """
    [件名]
    #{notification.subject}
    [日付]
    #{notification.action_date}
    [時間]
    #{notification.action_time}
    [通知]
    #{Ecto.DateTime.utc |> to_local_date_time}
    [説明]
    #{notification.summary}
    """
  end

  defp to_local_date_time(utc_date_time) do
    utc_date_time
    |> Ecto.DateTime.to_erl
    |> :calendar.universal_time_to_local_time
    |> Ecto.DateTime.from_erl
  end
end