defmodule Dogistics.Repo.Migrations.AddCoordinatesToPoints do
  use Ecto.Migration

  def change do
    alter table(:points) do
      add :coordinates, {:array, :float}, default: []
    end
  end
end
