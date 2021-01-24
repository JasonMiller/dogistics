defmodule Dogistics.Repo.Migrations.CreateDogsLegsJoinTable do
  use Ecto.Migration

  def change do
    create table(:dogs_legs, primary_key: false) do
      add :dog_id, references(:dogs, on_delete: :delete_all)
      add :leg_id, references(:legs, on_delete: :delete_all)
    end

    create index(:dogs_legs, [:dog_id])
    create index(:dogs_legs, [:leg_id])
  end
end
