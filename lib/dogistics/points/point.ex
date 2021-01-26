defmodule Dogistics.Points.Point do
  use Ecto.Schema
  import Ecto.Changeset

  schema "points" do
    field :location, :string

    timestamps()
  end

  @doc false
  def changeset(point, attrs) do
    point
    |> cast(attrs, [:location])
    |> validate_required([:location])
  end
end
