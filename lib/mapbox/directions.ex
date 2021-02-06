defmodule Mapbox.Directions do
  def get_attrs(
        %{
          "routes" => [
            %{
              "geometry" => %{"coordinates" => coordinates},
              "legs" => [%{"distance" => distance} | _]
            }
            | _
          ]
        } = response_json
      ) do
    %{
      "coordinates" => coordinates,
      "distance" => distance
    }
  end

  def get(list) do
    params = %{
      alternatives: true,
      geometries: "geojson",
      steps: true,
      access_token:
        "pk.eyJ1IjoibWlsbGxsbGx6IiwiYSI6ImNrazBkbjd6cjBnYTQydnBmbnNhOXB2NWIifQ.-nb92XoCw7zjc2ToVmssrQ"
    }

    coords =
      list
      |> Enum.map(fn [lng, lat] -> "#{lng},#{lat}" end)
      |> Enum.join(";")

    url =
      Enum.join(
        [
          URI.encode("https://api.mapbox.com/directions/v5/mapbox/driving/#{coords}"),
          URI.encode_query(params)
        ],
        "?"
      )

    {:ok, %HTTPoison.Response{body: response_body}} = HTTPoison.get(url)

    Jason.decode!(response_body)
  end
end
