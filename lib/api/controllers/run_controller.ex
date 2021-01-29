defmodule DogisticsWeb.API.RunController do
  use DogisticsWeb, :controller

  def fetch_features(conn, %{"id" => id}) do
    legs = Dogistics.Runs.get_run!(id).legs

    # features = direction_features(legs) ++ marker_features(legs)

    json = %{
      type: "FeatureCollection",
      features: direction_features(legs)
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

  def fetch_markers(conn, %{"id" => id}) do
    legs = Dogistics.Runs.get_run!(id).legs

    features =
      legs
      |> Enum.flat_map(fn %{start_point: start_point, end_point: end_point} = leg -> [start_point, end_point] end)
      |> Enum.uniq()
      |> Enum.map(fn %{id: id, coordinates: coordinates, location: location} = _point ->
        inbound = Enum.filter(legs, fn %{end_point: %{id: end_point_id}} = _leg -> end_point_id == id end)
        inbound_dogs =
          inbound
          |> Enum.map(fn %{dogs: dogs} -> Enum.count(dogs) end)
          |> Enum.sum()

        outbound = Enum.filter(legs, fn %{start_point: %{id: start_point_id}} = _leg -> start_point_id == id end)
        outbound_dogs =
          outbound
          |> Enum.map(fn %{dogs: dogs} -> Enum.count(dogs) end)
          |> Enum.sum()

        %{
          type: "Feature",
          geometry: %{
            type: "Point",
            coordinates: coordinates
          },
          properties: %{
            location: location,
            inbound_dogs: inbound_dogs,
            outbound_dogs: outbound_dogs,
          }
        }
      end)

      json = %{
        type: "FeatureCollection",
        features: features
      }

      json(conn, json)
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
