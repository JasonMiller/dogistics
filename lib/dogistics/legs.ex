defmodule Dogistics.Legs do
  @moduledoc """
  The Legs context.
  """

  import Ecto.Query, warn: false
  alias Dogistics.Repo

  alias Dogistics.Legs.Leg
  alias Dogistics.Runs.Run
  alias Dogistics.Points.Point

  @doc """
  Returns the list of legs.

  ## Examples

      iex> list_legs()
      [%Leg{}, ...]

  """
  def list_legs do
    Leg
    |> Repo.all()
    |> Repo.preload(:start_point)
    |> Repo.preload(:end_point)
  end

  @doc """
  Gets a single leg.

  Raises `Ecto.NoResultsError` if the Leg does not exist.

  ## Examples

      iex> get_leg!(123)
      %Leg{}

      iex> get_leg!(456)
      ** (Ecto.NoResultsError)

  """
  def get_leg!(id), do: Repo.get!(Leg, id)

  def get_or_create_leg(%Run{} = run, %Point{} = start_point, %Point{} = end_point, attrs \\ %{}) do
    case get_leg(run, start_point, end_point) do
      nil -> create_leg(run, start_point, end_point)
      leg -> leg
    end
  end

  def get_leg(%Run{} = run, %Point{} = start_point, %Point{} = end_point) do
    Repo.get_by(Leg,
      run_id: run.id,
      start_point_id: start_point.id,
      end_point_id: end_point.id
    )
  end

  @doc """
  Creates a leg.

  ## Examples

      iex> create_leg(%{field: value})
      {:ok, %Leg{}}

      iex> create_leg(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_leg(%Run{} = run, %Point{} = start_point, %Point{} = end_point, attrs \\ %{}) do
    attrs = maybe_merge_mapping_attrs(attrs, start_point, end_point)

    run
    |> Ecto.build_assoc(:legs)
    |> Leg.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:start_point, start_point)
    |> Ecto.Changeset.put_assoc(:end_point, end_point)
    |> Repo.insert()
  end

  def maybe_merge_mapping_attrs(attrs, %{coordinates: start_point}, %{coordinates: end_point}) do
    attrs =
      [start_point, end_point]
      |> Mapbox.Directions.get()
      |> Mapbox.Directions.get_attrs()

    Map.merge(attrs, attrs)
  end

  def maybe_merge_mapping_attrs(attrs, _, _), do: attrs

  @doc """
  Updates a leg.

  ## Examples

      iex> update_leg(leg, %{field: new_value})
      {:ok, %Leg{}}

      iex> update_leg(leg, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_leg(%Leg{} = leg, attrs) do
    leg
    |> Leg.changeset(attrs)
    |> Repo.update()
  end

  # def update_leg(%Leg{} = %{start_point: start_point, end_point: end_point} = leg) do
  #   update_leg(leg, maybe_merge_mapping_attrs(%{}, start_point, end_point))
  # end


  @doc """
  Deletes a leg.

  ## Examples

      iex> delete_leg(leg)
      {:ok, %Leg{}}

      iex> delete_leg(leg)
      {:error, %Ecto.Changeset{}}

  """
  def delete_leg(%Leg{} = leg) do
    Repo.delete(leg)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking leg changes.

  ## Examples

      iex> change_leg(leg)
      %Ecto.Changeset{data: %Leg{}}

  """
  def change_leg(%Leg{} = leg, attrs \\ %{}) do
    Leg.changeset(leg, attrs)
  end
end
