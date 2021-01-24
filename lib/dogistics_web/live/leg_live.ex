defmodule DogisticsWeb.LegLive do
  use DogisticsWeb, :live_view

  alias Dogistics.Legs

  def mount(_params, _session, socket) do
    {:ok, fetch(socket)}
  end

  def handle_event("add", %{"leg" => leg}, socket) do
    Legs.create_leg(leg)

    {:noreply, fetch(socket)}
  end

  defp fetch(socket) do
    assign(socket, legs: Legs.list_legs())
  end

  def handle_event("delete", %{"id" => id}, socket) do
    leg = Legs.get_leg!(id)
    {:ok, _leg} = Legs.delete_leg(leg)
    {:noreply, fetch(socket) }
  end
end