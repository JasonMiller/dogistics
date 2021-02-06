defmodule Dogistics.Runs.Run do
  use Ecto.Schema
  import Ecto.Changeset

  schema "runs" do
    has_many(:legs, Dogistics.Legs.Leg, on_replace: :delete)
    has_many(:dogs, Dogistics.Dogs.Dog)
    has_many(:points, Dogistics.Points.Point)

    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(run, attrs) do
    run
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
