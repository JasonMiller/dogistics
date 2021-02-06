defmodule Dogistics.Points.Point do
  use Ecto.Schema
  import Ecto.Changeset

  schema "points" do
    field :location, :string
    field :coordinates, {:array, :float}
    field :order, :integer

    belongs_to(:run, Dogistics.Runs.Run)

    has_many(:inbound_legs, Dogistics.Legs.Leg, foreign_key: :end_point_id, on_delete: :delete_all)

    has_many(:outbound_legs, Dogistics.Legs.Leg,
      foreign_key: :start_point_id,
      on_delete: :delete_all
    )

    timestamps()
  end

  @doc false
  def changeset(point, attrs) do
    attrs = maybe_put_coordinates(attrs)

    point
    |> cast(attrs, [:location, :coordinates, :order])
    |> validate_required([:location, :coordinates])
  end

  defp maybe_put_coordinates(%{"location" => location} = attrs) do
    Map.put(attrs, "coordinates", Mapbox.Geocoding.get_coordinates(location))
  end

  defp maybe_put_coordinates(attrs), do: attrs
end
