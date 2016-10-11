defmodule Notify.Repo.Migrations.CreateNotification do
  use Ecto.Migration

  def change do
    create table(:notifications) do
      add :subject, :string
      add :action_date, :date
      add :action_time, :time
      add :notify_before, :integer
      add :summary, :text
      add :notify_date_time, :datetime
      add :sent, :boolean, default: false, null: false

      timestamps()
    end

  end
end
