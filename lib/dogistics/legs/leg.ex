defmodule Dogistics.Legs.Leg do
  use Ecto.Schema
  import Ecto.Changeset

  schema "legs" do
    belongs_to(:run, Dogistics.Runs.Run)

    field :end_point, :string
    field :start_point, :string

    timestamps()
  end

  @doc false
  def changeset(leg, attrs) do
    leg
    |> cast(attrs, [:start_point, :end_point])
    |> validate_required([:start_point, :end_point])
  end
end
