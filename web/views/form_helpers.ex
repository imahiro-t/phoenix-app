defmodule Notify.FormHelpers do
  use Phoenix.HTML

  def normal_button(value, opts) do
    opts = Keyword.put_new(opts, :type, "button")
    content_tag(:button, html_escape(value), opts)
  end

  def date_input(form, field, opts) do
    input(:date, form, field, opts)
  end

  def time_input(form, field, opts) do
    input(:time, form, field, opts)
  end

  defp input(type, form, field, opts) do
    opts =
      opts
      |> Keyword.put_new(:type, type)
      |> Keyword.put_new(:id, field_id(form, field))
      |> Keyword.put_new(:name, field_name(form, field))
      |> Keyword.put_new(:value, field_value(form, field))
    tag(:input, opts)
  end

end