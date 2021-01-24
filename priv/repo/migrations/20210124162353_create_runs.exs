defmodule Dogistics.Repo.Migrations.CreateRuns do
  use Ecto.Migration

  def change do
    create table(:runs) do
      add :name, :string

      timestamps()
    end

  end
end
