defmodule Dogistics.RunsTest do
  use Dogistics.DataCase

  alias Dogistics.Runs

  describe "runs" do
    alias Dogistics.Runs.Run

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def run_fixture(attrs \\ %{}) do
      {:ok, run} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Runs.create_run()

      run
    end

    test "list_runs/0 returns all runs" do
      run = run_fixture()
      assert Runs.list_runs() == [run]
    end

    test "get_run!/1 returns the run with given id" do
      run = run_fixture()
      assert Runs.get_run!(run.id) == run
    end

    test "create_run/1 with valid data creates a run" do
      assert {:ok, %Run{} = run} = Runs.create_run(@valid_attrs)
      assert run.name == "some name"
    end

    test "create_run/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Runs.create_run(@invalid_attrs)
    end

    test "update_run/2 with valid data updates the run" do
      run = run_fixture()
      assert {:ok, %Run{} = run} = Runs.update_run(run, @update_attrs)
      assert run.name == "some updated name"
    end

    test "update_run/2 with invalid data returns error changeset" do
      run = run_fixture()
      assert {:error, %Ecto.Changeset{}} = Runs.update_run(run, @invalid_attrs)
      assert run == Runs.get_run!(run.id)
    end

    test "delete_run/1 deletes the run" do
      run = run_fixture()
      assert {:ok, %Run{}} = Runs.delete_run(run)
      assert_raise Ecto.NoResultsError, fn -> Runs.get_run!(run.id) end
    end

    test "change_run/1 returns a run changeset" do
      run = run_fixture()
      assert %Ecto.Changeset{} = Runs.change_run(run)
    end
  end
end
