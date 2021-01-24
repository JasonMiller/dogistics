defmodule Dogistics.Legs.Leg do
  use Ecto.Schema
  import Ecto.Changeset

  schema "legs" do
    belongs_to(:run, Dogistics.Runs.Run)
    many_to_many(:dogs, Dogistics.Dogs.Dog, join_through: "dogs_legs")

    field :end_point, :string
    field :start_point, :string

    timestamps()
  end

  @doc false
  def changeset(leg, attrs) do
    leg
    |> cast(attrs, [:start_point, :end_point])
    |> maybe_put_dogs(attrs)
    |> validate_required([:start_point, :end_point])
  end

  def maybe_put_dogs(changeset, %{"dogs" => dogs}) do
    dogs =
      dogs
      |> Map.keys()
      |> Dogistics.Dogs.list_dogs_by_id()

    Ecto.Changeset.put_assoc(changeset, :dogs, dogs)
  end

  def maybe_put_dogs(changeset, _), do: changeset
end
