defmodule DogisticsWeb.RunLive do
  use DogisticsWeb, :live_view

  alias Dogistics.Dogs
  alias Dogistics.Legs
  alias Dogistics.Points
  alias Dogistics.Runs

  def mount(%{"id" => id}, _session, socket) do
    {:ok, fetch(socket, id)}
  end

  def handle_event(
        "add_leg",
        %{"start_point" => start_point, "end_point" => end_point} = attrs,
        %{assigns: %{run: run}} = socket
      ) do
    start_point = Points.get_or_create_point(run, start_point)
    end_point = Points.get_or_create_point(run, end_point)

    Legs.create_leg(run, start_point, end_point, Map.get(attrs, "leg", %{}))

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

  def handle_event(
        "add_point",
        %{"point" => point},
        %{assigns: %{run: %{id: run_id} = run}} = socket
      ) do
    {:ok, point} = Points.create_point(run, point)

    if Enum.any?(run.points) do
      start_point = List.last(run.points)

      Legs.get_or_create_leg(run, start_point, point)
    end

    {:noreply, fetch(socket, run_id)}
  end

  def handle_event("delete_point", %{"id" => id}, %{assigns: %{run: %{id: run_id}}} = socket) do
    {:ok, _point} =
      id
      |> Points.get_point!()
      |> Points.delete_point()

    # rebuild_legs(run_id)

    {:noreply, fetch(socket, run_id)}
  end

  def handle_event(
        "insert_after",
        %{"id" => id, "insert_after_id" => insert_after_id},
        %{assigns: %{run: %{id: run_id} = run}} = socket
      ) do
    point = Points.get_point!(id)
    insert_after_point = Points.get_point!(insert_after_id)

    Points.delete_legs(point)

    Legs.get_or_create_leg(run, insert_after_point, point)

    for outbound_leg <- insert_after_point.outbound_legs do
      Legs.get_or_create_leg(run, point, outbound_leg.end_point)

      Legs.delete_leg(outbound_leg)
    end

    {:noreply, fetch(socket, run_id)}
  end

  defp rebuild_legs(run_id) do
    run = Runs.get_run!(run_id)

    case run.points do
      [] ->
        nil

      [_ | nil] ->
        nil

      points ->
        points
        |> Enum.chunk_every(2, 1)
        |> Enum.each(fn [start_point, end_point] ->
          Legs.get_or_create_leg(run, start_point, end_point)
        end)
    end
  end

  defp fetch(socket, run_id) do
    run = Runs.get_run!(run_id)

    assign_run(socket, run)
  end

  defp assign_run(socket, run) do
    assign(socket, run: run, legs: run.legs, dogs: run.dogs, points: run.points)
  end
end
