defmodule Dogistics.Points do
  @moduledoc """
  The Points context.
  """

  import Ecto.Query, warn: false
  alias Dogistics.Repo

  alias Dogistics.Points.Point

  @doc """
  Returns the list of points.

  ## Examples

      iex> list_points()
      [%Point{}, ...]

  """
  def list_points do
    Repo.all(Point)
  end

  @doc """
  Gets a single point.

  Raises `Ecto.NoResultsError` if the Point does not exist.

  ## Examples

      iex> get_point!(123)
      %Point{}

      iex> get_point!(456)
      ** (Ecto.NoResultsError)

  """
  def get_point!(id) do
    query =
      from(point in Point,
        left_join: inbound_legs in assoc(point, :inbound_legs),
        left_join: start_point in assoc(inbound_legs, :start_point),
        left_join: outbound_legs in assoc(point, :outbound_legs),
        left_join: end_point in assoc(outbound_legs, :end_point),
        where: point.id == ^id,
        preload: [
          inbound_legs: {inbound_legs, [start_point: start_point]},
          outbound_legs: {outbound_legs, [end_point: end_point]}
        ]
      )

    Repo.one(query)
  end

  @doc """
  Creates a point.

  ## Examples

      iex> create_point(%{field: value})
      {:ok, %Point{}}

      iex> create_point(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_point(attrs) do
    %Point{}
    |> Point.changeset(attrs)
    |> Repo.insert()
  end

  def create_point(run, attrs) do
    # attrs = Map.put(attrs, "order", (get_max_order(run) || 0) + 1)

    run
    |> Ecto.build_assoc(:points)
    |> Point.changeset(attrs)
    |> Repo.insert()
  end

  def get_max_order(run) do
    query =
      from(points in Point,
        join: run in assoc(points, :run),
        select: max(points.order),
        group_by: run.id
      )

    Repo.one(query)
  end

  def get_or_create_point(run, attrs) do
    attrs_list =
      attrs
      |> Map.put("run_id", run.id)
      |> Keyword.new(fn {k, v} -> {String.to_existing_atom(k), v} end)

    {:ok, point} =
      case Repo.get_by(Point, attrs_list) do
        nil -> create_point(run, attrs)
        point -> {:ok, point}
      end

    point
  end

  @doc """
  Updates a point.

  ## Examples

      iex> update_point(point, %{field: new_value})
      {:ok, %Point{}}

      iex> update_point(point, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_point(%Point{} = point, attrs) do
    point
    |> Point.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a point.

  ## Examples

      iex> delete_point(point)
      {:ok, %Point{}}

      iex> delete_point(point)
      {:error, %Ecto.Changeset{}}

  """
  def delete_point(%Point{} = point) do
    Repo.delete(point)
  end

  def delete_legs(%Point{} = point) do
    legs = point.inbound_legs ++ point.outbound_legs

    for leg <- legs do
      Dogistics.Legs.delete_leg(leg)
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking point changes.

  ## Examples

      iex> change_point(point)
      %Ecto.Changeset{data: %Point{}}

  """
  def change_point(%Point{} = point, attrs \\ %{}) do
    Point.changeset(point, attrs)
  end
end
