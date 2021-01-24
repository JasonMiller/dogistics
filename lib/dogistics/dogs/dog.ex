defmodule Dogistics.Dogs.Dog do
  use Ecto.Schema
  import Ecto.Changeset

  schema "dogs" do
    belongs_to(:run, Dogistics.Runs.Run)
    many_to_many(:legs, Dogistics.Legs.Leg, join_through: "dogs_legs")

    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(dog, attrs) do
    dog
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
