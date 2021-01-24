defmodule Dogistics.Runs.Run do
  use Ecto.Schema
  import Ecto.Changeset

  schema "runs" do
    has_many(:legs, Dogistics.Legs.Leg)

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
