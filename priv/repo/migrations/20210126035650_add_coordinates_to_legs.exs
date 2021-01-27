defmodule Dogistics.Repo.Migrations.AddCoordinatesToLegs do
  use Ecto.Migration

  def change do
    alter table(:legs) do
      add :coordinates, {:array, {:array, :float}}, default: []
    end
  end
end
