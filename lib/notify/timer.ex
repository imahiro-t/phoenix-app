defmodule Notify.Timer do
  use GenServer

  def start_link(name) do
    GenServer.start_link(__MODULE__, :ok, name: name)
  end

  def init(:ok) do
    check_forever
    {:ok, %{}}
  end

  def handle_info(:check_notify, _) do
    spawn(fn -> Notify.NotifyChecker.check_notify end)
    check_forever
    {:noreply, ""}
  end

  defp check_forever do
    {_, _, sec} = Ecto.Time.utc |> Ecto.Time.to_erl
    Process.send_after(self, :check_notify, (60-sec)*1000)
  end

end
