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
    Repo.all(Leg)
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

  @doc """
  Creates a leg.

  ## Examples

      iex> create_leg(%{field: value})
      {:ok, %Leg{}}

      iex> create_leg(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_leg(%Run{} = run, %Point{} = start_point, %Point{} = end_point, attrs \\ %{}) do
    run
    |> Ecto.build_assoc(:legs)
    |> Leg.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:start_point, start_point)
    |> Ecto.Changeset.put_assoc(:end_point, end_point)
    |> Repo.insert()
  end

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
