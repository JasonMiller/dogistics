defmodule Dogistics.Legs.Leg do
  use Ecto.Schema
  import Ecto.Changeset

  schema "legs" do
    belongs_to(:run, Dogistics.Runs.Run)
    belongs_to(:end_point, Dogistics.Points.Point, foreign_key: :end_point_id)
    belongs_to(:start_point, Dogistics.Points.Point, foreign_key: :start_point_id)

    many_to_many(:dogs, Dogistics.Dogs.Dog, join_through: "dogs_legs")

    field :coordinates, {:array, {:array, :float}}
    field :distance, :float

    timestamps()
  end

  @doc false
  def changeset(leg, attrs) do
    leg
    |> cast(attrs, [:coordinates, :distance])
    |> foreign_key_constraint(:start_point_id)
    |> foreign_key_constraint(:end_point_id)
    |> validate_required([:coordinates, :distance])
    |> maybe_put_dogs(attrs)
  end

  def maybe_put_dogs(changeset, %{"dogs" => dogs}) do
    dogs =
      dogs
      |> Enum.filter(fn {_id, checked} -> checked == "true" end)
      |> Enum.map(fn {id, _checked} -> id end)
      |> Dogistics.Dogs.list_dogs_by_id()

    Ecto.Changeset.put_assoc(changeset, :dogs, dogs)
  end

  def maybe_put_dogs(changeset, _), do: changeset
end
