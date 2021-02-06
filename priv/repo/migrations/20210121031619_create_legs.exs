defmodule Dogistics.Repo.Migrations.CreateLegs do
  use Ecto.Migration

  def change do
    create table(:legs) do
      add :start_point, :string
      add :end_point, :string

      timestamps()
    end
  end
end
