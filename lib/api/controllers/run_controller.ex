defmodule DogisticsWeb.API.RunController do
  use DogisticsWeb, :controller

  def fetch_features(conn, %{"id" => id}) do
    legs = Dogistics.Runs.get_run!(id).legs

    features = direction_features(legs) ++ marker_features(legs)

    json = %{
      type: "FeatureCollection",
      features: features
    }

    json(conn, json)
  end

  defp direction_features(legs) do
    Enum.map(legs, fn %{coordinates: coordinates} ->
      %{
        type: "Feature",
        geometry: %{
          type: "LineString",
          coordinates: coordinates
        }
      }
    end)
  end

  defp marker_features(legs) do
    legs
    |> Enum.flat_map(fn %{start_point: %{coordinates: start_point}, end_point: %{coordinates: end_point}} = leg -> [start_point, end_point] end)
    |> Enum.uniq()
    |> Enum.map(fn coordinates ->
      %{
        type: "Feature",
        geometry: %{
          type: "Point",
          coordinates: coordinates
        }
      }
    end)
  end

  def fetch_bounds(conn, %{"id" => id}) do
    legs = Dogistics.Runs.get_run!(id).legs

    # could probably be done better with reduce
    coords =
      legs
      |> Enum.flat_map(fn %{start_point: %{coordinates: start_point}, end_point: %{coordinates: end_point}} = leg -> [start_point, end_point] end)
      |> Enum.uniq()

    json =
      if Enum.empty?(coords) do
        nil
      else
        {min_lng, max_lng} =
          coords
          |> Enum.map(fn [lng, _] -> lng end)
          |> Enum.min_max()

        {min_lat, max_lat} =
          coords
          |> Enum.map(fn [_, lat] -> lat end)
          |> Enum.min_max()

        [
          [min_lng, min_lat],
          [max_lng, max_lat]
        ]
      end

      json(conn, json)
  end
end
