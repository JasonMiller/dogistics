defmodule Dogistics.Repo.Migrations.AddRunIdToLegs do
  use Ecto.Migration

  def change do
    alter table(:legs) do
      add :run_id, references(:runs, on_delete: :nothing)
    end

    create index(:legs, [:run_id])
  end
end
