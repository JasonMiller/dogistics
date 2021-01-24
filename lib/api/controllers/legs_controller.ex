defmodule DogisticsWeb.API.LegsController do
  use DogisticsWeb, :controller

  def fetch_directions(conn, _params) do
    legs = Dogistics.Legs.list_legs()

    features = direction_features(legs) ++ marker_features(legs)

    json = %{
      type: "FeatureCollection",
      features: features
    }

    json(conn, json)
  end

  defp direction_features(legs) do
    Enum.map(legs, fn %{start_point: start_point, end_point: end_point} = leg ->
      coordinates =
        [start_point, end_point]
        |> Enum.map(& Mapbox.Geocoding.get_coordinates(&1))
        |> Mapbox.Directions.get_coordinates()

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
    |> Enum.flat_map(fn %{start_point: start_point, end_point: end_point} = leg -> [start_point, end_point] end)
    |> Enum.uniq()
    |> Enum.map(fn point ->
      %{
        type: "Feature",
        geometry: %{
          type: "Point",
          coordinates: Mapbox.Geocoding.get_coordinates(point)
        }
      }
    end)
  end
end
