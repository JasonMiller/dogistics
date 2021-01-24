defmodule DogisticsWeb.TabsHelper do
  use Phoenix.HTML

  def tabs(do: content) do
    content_tag(:div, content, class: "tabs")
  end

  def tab(id, text, checked \\ false, do: content) do
    [
      tag(:input,
        type: "radio",
        id: id,
        class: "tab__toggle",
        checked: checked,
        name: "tabs",
        phx_update: "ignore"
      ),
      content_tag(:label, text, for: id, class: "tab__label"),
      content_tag(:div, content, class: "tab__content")
    ]
  end
end
