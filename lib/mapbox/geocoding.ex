defmodule Mapbox.Geocoding do
  def get_coordinates(place) do
    case get(place) do
      %{"features" => [%{"geometry" => %{"coordinates" => coordinates}} | _]} -> coordinates
      _ -> raise place
    end
  end

  def get(place \\ "Macon, Georgia") do
    params = %{
      access_token: "pk.eyJ1IjoibWlsbGxsbGx6IiwiYSI6ImNrazBkbjd6cjBnYTQydnBmbnNhOXB2NWIifQ.-nb92XoCw7zjc2ToVmssrQ",
      cachebuster: 1611101950528,
      autocomplete: true
    }

    url = Enum.join([
      URI.encode("https://api.mapbox.com/geocoding/v5/mapbox.places/#{place}.json"),
      URI.encode_query(params)
    ], "?")

    IO.puts(url)

    {:ok, %HTTPoison.Response{body: response_body}} = HTTPoison.get(url)

    Jason.decode!(response_body)
  end
end