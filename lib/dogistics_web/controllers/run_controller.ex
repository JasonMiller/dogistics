defmodule DogisticsWeb.RunController do
  use DogisticsWeb, :controller

  alias Dogistics.Runs
  alias Dogistics.Runs.Run

  def index(conn, _params) do
    runs = Runs.list_runs()
    render(conn, "index.html", runs: runs)
  end

  def new(conn, _params) do
    changeset = Runs.change_run(%Run{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"run" => run_params}) do
    case Runs.create_run(run_params) do
      {:ok, run} ->
        conn
        |> put_flash(:info, "Run created successfully.")
        |> redirect(to: Routes.run_path(conn, :edit, run))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    run = Runs.get_run!(id)
    {:ok, _run} = Runs.delete_run(run)

    conn
    |> put_flash(:info, "Run deleted successfully.")
    |> redirect(to: Routes.run_path(conn, :index))
  end
end
