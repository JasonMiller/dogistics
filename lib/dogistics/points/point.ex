defmodule Dogistics.Points.Point do
  use Ecto.Schema
  import Ecto.Changeset

  schema "points" do
    field :location, :string
    field :coordinates, {:array, :float}

    timestamps()
  end

  @doc false
  def changeset(point, attrs) do
    attrs = maybe_put_coordinates(attrs)

    point
    |> cast(attrs, [:location, :coordinates])
    |> validate_required([:location, :coordinates])
  end

  defp maybe_put_coordinates(%{"location" => location} = attrs) do
    Map.put(attrs, "coordinates", Mapbox.Geocoding.get_coordinates(location))
  end

  defp maybe_put_coordinates(attrs), do: attrs
end
