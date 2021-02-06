defmodule Dogistics.Repo.Migrations.AddDistanceToLegs do
  use Ecto.Migration

  def change do
    alter table(:legs) do
      add :distance, :float, default: 0, nil: false
    end
  end
end
