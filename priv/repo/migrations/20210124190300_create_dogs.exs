defmodule Dogistics.Repo.Migrations.CreateDogs do
  use Ecto.Migration

  def change do
    create table(:dogs) do
      add :name, :string

      add :run_id, references(:runs, on_delete: :delete_all)

      timestamps()
    end

    create index(:dogs, [:run_id])
  end
end
