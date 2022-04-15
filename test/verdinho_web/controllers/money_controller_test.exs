defmodule VerdinhoWeb.MoneyControllerTest do
  use VerdinhoWeb.ConnCase

  import Verdinho.TransactionsFixtures

  @create_attrs %{currency: "some currency", destiny: "some destiny", id: 42, owner: "some owner", time: ~U[2022-04-14 22:59:00Z], value: "120.5"}
  @update_attrs %{currency: "some updated currency", destiny: "some updated destiny", id: 43, owner: "some updated owner", time: ~U[2022-04-15 22:59:00Z], value: "456.7"}
  @invalid_attrs %{currency: nil, destiny: nil, id: nil, owner: nil, time: nil, value: nil}

  describe "index" do
    test "lists all transactions", %{conn: conn} do
      conn = get(conn, Routes.money_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Transactions"
    end
  end

  describe "new money" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.money_path(conn, :new))
      assert html_response(conn, 200) =~ "New Money"
    end
  end

  describe "create money" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.money_path(conn, :create), money: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.money_path(conn, :show, id)

      conn = get(conn, Routes.money_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Money"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.money_path(conn, :create), money: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Money"
    end
  end

  describe "edit money" do
    setup [:create_money]

    test "renders form for editing chosen money", %{conn: conn, money: money} do
      conn = get(conn, Routes.money_path(conn, :edit, money))
      assert html_response(conn, 200) =~ "Edit Money"
    end
  end

  describe "update money" do
    setup [:create_money]

    test "redirects when data is valid", %{conn: conn, money: money} do
      conn = put(conn, Routes.money_path(conn, :update, money), money: @update_attrs)
      assert redirected_to(conn) == Routes.money_path(conn, :show, money)

      conn = get(conn, Routes.money_path(conn, :show, money))
      assert html_response(conn, 200) =~ "some updated currency"
    end

    test "renders errors when data is invalid", %{conn: conn, money: money} do
      conn = put(conn, Routes.money_path(conn, :update, money), money: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Money"
    end
  end

  describe "delete money" do
    setup [:create_money]

    test "deletes chosen money", %{conn: conn, money: money} do
      conn = delete(conn, Routes.money_path(conn, :delete, money))
      assert redirected_to(conn) == Routes.money_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.money_path(conn, :show, money))
      end
    end
  end

  defp create_money(_) do
    money = money_fixture()
    %{money: money}
  end
end
