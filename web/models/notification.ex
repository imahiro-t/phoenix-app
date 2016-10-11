defmodule Notify.Notification do
  use Notify.Web, :model

  schema "notifications" do
    field :subject, :string
    field :action_date, Ecto.Date
    field :action_time, Ecto.Time
    field :notify_before, :integer
    field :summary, :string
    field :notify_date_time, Ecto.DateTime
    field :sent, :boolean, default: false

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:subject, :action_date, :action_time, :notify_before, :summary])
    |> validate_required([:subject, :action_date, :action_time, :notify_before])
  end
end
