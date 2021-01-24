defmodule DogisticsWeb.RunLive do
  use DogisticsWeb, :live_view

  alias Dogistics.Dogs
  alias Dogistics.Legs
  alias Dogistics.Runs

  def mount(%{"id" => id}, _session, socket) do
    {:ok, fetch(socket, id)}
  end

  def handle_event("add_leg", %{"leg" => leg}, %{assigns: %{run: run}} = socket) do
    Legs.create_leg(run, leg)

    {:noreply, fetch(socket, run.id)}
  end

  def handle_event("delete_leg", %{"id" => id}, %{assigns: %{run: run}} = socket) do
    {:ok, _leg} =
      id
      |> Legs.get_leg!()
      |> Legs.delete_leg()

    {:noreply, fetch(socket, run.id)}
  end

  def handle_event("add_dog", %{"dog" => dog}, %{assigns: %{run: run}} = socket) do
    Dogs.create_dog(run, dog)

    {:noreply, fetch(socket, run.id)}
  end

  def handle_event("delete_dog", %{"id" => id}, %{assigns: %{run: run}} = socket) do
    {:ok, _dog} =
      id
      |> Dogs.get_dog!()
      |> Dogs.delete_dog()

    {:noreply, fetch(socket, run.id)}
  end

  defp fetch(socket, run_id) do
    run = Runs.get_run!(run_id)

    assign(socket, run: run, legs: run.legs, dogs: run.dogs)
  end
end