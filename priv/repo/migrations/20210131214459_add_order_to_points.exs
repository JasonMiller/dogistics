defmodule Dogistics.Repo.Migrations.AddOrderToPoints do
  use Ecto.Migration

  def change do
    alter table(:points) do
      add :order, :integer, default: 0, nil: false
    end
  end
end
