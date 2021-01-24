defmodule Dogistics.DogsTest do
  use Dogistics.DataCase

  alias Dogistics.Dogs

  describe "dogs" do
    alias Dogistics.Dogs.Dog

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def dog_fixture(attrs \\ %{}) do
      {:ok, dog} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Dogs.create_dog()

      dog
    end

    test "list_dogs/0 returns all dogs" do
      dog = dog_fixture()
      assert Dogs.list_dogs() == [dog]
    end

    test "get_dog!/1 returns the dog with given id" do
      dog = dog_fixture()
      assert Dogs.get_dog!(dog.id) == dog
    end

    test "create_dog/1 with valid data creates a dog" do
      assert {:ok, %Dog{} = dog} = Dogs.create_dog(@valid_attrs)
      assert dog.name == "some name"
    end

    test "create_dog/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Dogs.create_dog(@invalid_attrs)
    end

    test "update_dog/2 with valid data updates the dog" do
      dog = dog_fixture()
      assert {:ok, %Dog{} = dog} = Dogs.update_dog(dog, @update_attrs)
      assert dog.name == "some updated name"
    end

    test "update_dog/2 with invalid data returns error changeset" do
      dog = dog_fixture()
      assert {:error, %Ecto.Changeset{}} = Dogs.update_dog(dog, @invalid_attrs)
      assert dog == Dogs.get_dog!(dog.id)
    end

    test "delete_dog/1 deletes the dog" do
      dog = dog_fixture()
      assert {:ok, %Dog{}} = Dogs.delete_dog(dog)
      assert_raise Ecto.NoResultsError, fn -> Dogs.get_dog!(dog.id) end
    end

    test "change_dog/1 returns a dog changeset" do
      dog = dog_fixture()
      assert %Ecto.Changeset{} = Dogs.change_dog(dog)
    end
  end
end
