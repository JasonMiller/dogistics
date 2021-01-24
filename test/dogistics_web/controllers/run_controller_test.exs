defmodule DogisticsWeb.RunControllerTest do
  use DogisticsWeb.ConnCase

  alias Dogistics.Runs

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:run) do
    {:ok, run} = Runs.create_run(@create_attrs)
    run
  end

  describe "index" do
    test "lists all runs", %{conn: conn} do
      conn = get(conn, Routes.run_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Runs"
    end
  end

  describe "new run" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.run_path(conn, :new))
      assert html_response(conn, 200) =~ "New Run"
    end
  end

  describe "create run" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.run_path(conn, :create), run: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.run_path(conn, :show, id)

      conn = get(conn, Routes.run_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Run"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.run_path(conn, :create), run: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Run"
    end
  end

  describe "edit run" do
    setup [:create_run]

    test "renders form for editing chosen run", %{conn: conn, run: run} do
      conn = get(conn, Routes.run_path(conn, :edit, run))
      assert html_response(conn, 200) =~ "Edit Run"
    end
  end

  describe "update run" do
    setup [:create_run]

    test "redirects when data is valid", %{conn: conn, run: run} do
      conn = put(conn, Routes.run_path(conn, :update, run), run: @update_attrs)
      assert redirected_to(conn) == Routes.run_path(conn, :show, run)

      conn = get(conn, Routes.run_path(conn, :show, run))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, run: run} do
      conn = put(conn, Routes.run_path(conn, :update, run), run: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Run"
    end
  end

  describe "delete run" do
    setup [:create_run]

    test "deletes chosen run", %{conn: conn, run: run} do
      conn = delete(conn, Routes.run_path(conn, :delete, run))
      assert redirected_to(conn) == Routes.run_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.run_path(conn, :show, run))
      end
    end
  end

  defp create_run(_) do
    run = fixture(:run)
    %{run: run}
  end
end
