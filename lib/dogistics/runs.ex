defmodule Dogistics.Runs do
  @moduledoc """
  The Runs context.
  """

  import Ecto.Query, warn: false
  alias Dogistics.Repo

  alias Dogistics.Runs.Run

  @doc """
  Returns the list of runs.

  ## Examples

      iex> list_runs()
      [%Run{}, ...]

  """
  def list_runs do
    Repo.all(Run)
  end

  @doc """
  Gets a single run.

  Raises `Ecto.NoResultsError` if the Run does not exist.

  ## Examples

      iex> get_run!(123)
      %Run{}

      iex> get_run!(456)
      ** (Ecto.NoResultsError)

  """
  def get_run!(id) do
    query =
      from(run in Run,
        left_join: dogs in assoc(run, :dogs),
        left_join: legs in assoc(run, :legs),
        left_join: legs_dogs in assoc(legs, :dogs),
        left_join: start_point in assoc(legs, :start_point),
        left_join: end_point in assoc(legs, :end_point),
        left_join: points in assoc(run, :points),
        where: run.id == ^id,
        preload: [
          dogs: dogs,
          points: points,
          legs: {legs, [dogs: legs_dogs, start_point: start_point, end_point: end_point]}
        ],
        order_by: [asc: points.id, asc: legs.id, asc: dogs.name]
      )

    Repo.one(query)
  end
  # def get_run!(id) do
  #   query =
  #     from(run in Run,
  #       left_join: dogs in assoc(run, :dogs),
  #       left_join: legs in assoc(run, :legs),
  #       left_join: legs_dogs in assoc(legs, :dogs),
  #       left_join: start_point in assoc(legs, :start_point),
  #       left_join: end_point in assoc(legs, :end_point),
  #       left_join: points in assoc(run, :points),
  #       where: run.id == ^id,
  #       preload: [
  #         dogs: dogs,
  #         points: points,
  #         legs: {legs, [dogs: legs_dogs, start_point: start_point, end_point: end_point]}
  #       ],
  #       order_by: [asc: points.id, asc: legs.id, asc: dogs.name]
  #     )

  #   Repo.one(query)
  # end

  @doc """
  Creates a run.

  ## Examples

      iex> create_run(%{field: value})
      {:ok, %Run{}}

      iex> create_run(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_run(attrs \\ %{}) do
    %Run{}
    |> Run.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a run.

  ## Examples

      iex> update_run(run, %{field: new_value})
      {:ok, %Run{}}

      iex> update_run(run, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_run(%Run{} = run, attrs) do
    run
    |> Run.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a run.

  ## Examples

      iex> delete_run(run)
      {:ok, %Run{}}

      iex> delete_run(run)
      {:error, %Ecto.Changeset{}}

  """
  def delete_run(%Run{} = run) do
    Repo.delete(run)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking run changes.

  ## Examples

      iex> change_run(run)
      %Ecto.Changeset{data: %Run{}}

  """
  def change_run(%Run{} = run, attrs \\ %{}) do
    Run.changeset(run, attrs)
  end
end
