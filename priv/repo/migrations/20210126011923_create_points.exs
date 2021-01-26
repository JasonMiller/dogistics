defmodule Dogistics.Repo.Migrations.CreatePoints do
  use Ecto.Migration

  def change do
    create table(:points) do
      add :location, :string

      timestamps()
    end
  end
end
