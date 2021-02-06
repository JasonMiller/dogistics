defmodule Dogistics.Repo.Migrations.AddRunIdToPoints do
  use Ecto.Migration

  def change do
    alter table(:points) do
      add :run_id, references(:runs, on_delete: :delete_all)
    end

    create index(:points, [:run_id])
  end
end
