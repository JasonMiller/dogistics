defmodule Dogistics.LegsTest do
  use Dogistics.DataCase

  alias Dogistics.Legs

  describe "legs" do
    alias Dogistics.Legs.Leg

    @valid_attrs %{end_point: "some end_point", start_point: "some start_point"}
    @update_attrs %{end_point: "some updated end_point", start_point: "some updated start_point"}
    @invalid_attrs %{end_point: nil, start_point: nil}

    def leg_fixture(attrs \\ %{}) do
      {:ok, leg} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Legs.create_leg()

      leg
    end

    test "list_legs/0 returns all legs" do
      leg = leg_fixture()
      assert Legs.list_legs() == [leg]
    end

    test "get_leg!/1 returns the leg with given id" do
      leg = leg_fixture()
      assert Legs.get_leg!(leg.id) == leg
    end

    test "create_leg/1 with valid data creates a leg" do
      assert {:ok, %Leg{} = leg} = Legs.create_leg(@valid_attrs)
      assert leg.end_point == "some end_point"
      assert leg.start_point == "some start_point"
    end

    test "create_leg/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Legs.create_leg(@invalid_attrs)
    end

    test "update_leg/2 with valid data updates the leg" do
      leg = leg_fixture()
      assert {:ok, %Leg{} = leg} = Legs.update_leg(leg, @update_attrs)
      assert leg.end_point == "some updated end_point"
      assert leg.start_point == "some updated start_point"
    end

    test "update_leg/2 with invalid data returns error changeset" do
      leg = leg_fixture()
      assert {:error, %Ecto.Changeset{}} = Legs.update_leg(leg, @invalid_attrs)
      assert leg == Legs.get_leg!(leg.id)
    end

    test "delete_leg/1 deletes the leg" do
      leg = leg_fixture()
      assert {:ok, %Leg{}} = Legs.delete_leg(leg)
      assert_raise Ecto.NoResultsError, fn -> Legs.get_leg!(leg.id) end
    end

    test "change_leg/1 returns a leg changeset" do
      leg = leg_fixture()
      assert %Ecto.Changeset{} = Legs.change_leg(leg)
    end
  end
end
