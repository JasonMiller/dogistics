defmodule Dogistics.Repo.Migrations.AddPointsToLegs do
  use Ecto.Migration

  def change do
    alter table(:legs) do
      add :start_point_id, references(:points)
      add :end_point_id, references(:points)
      remove :start_point
      remove :end_point
    end

    create index(:legs, [:start_point_id])
    create index(:legs, [:end_point_id])
  end
end
