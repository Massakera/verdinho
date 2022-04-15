defmodule Verdinho.TransactionsTest do
  use Verdinho.DataCase

  alias Verdinho.Transactions

  describe "transactions" do
    alias Verdinho.Transactions.Money

    import Verdinho.TransactionsFixtures

    @invalid_attrs %{currency: nil, destiny: nil, id: nil, owner: nil, time: nil, value: nil}

    test "list_transactions/0 returns all transactions" do
      money = money_fixture()
      assert Transactions.list_transactions() == [money]
    end

    test "get_money!/1 returns the money with given id" do
      money = money_fixture()
      assert Transactions.get_money!(money.id) == money
    end

    test "create_money/1 with valid data creates a money" do
      valid_attrs = %{currency: "some currency", destiny: "some destiny", id: 42, owner: "some owner", time: ~U[2022-04-14 22:59:00Z], value: "120.5"}

      assert {:ok, %Money{} = money} = Transactions.create_money(valid_attrs)
      assert money.currency == "some currency"
      assert money.destiny == "some destiny"
      assert money.id == 42
      assert money.owner == "some owner"
      assert money.time == ~U[2022-04-14 22:59:00Z]
      assert money.value == Decimal.new("120.5")
    end

    test "create_money/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transactions.create_money(@invalid_attrs)
    end

    test "update_money/2 with valid data updates the money" do
      money = money_fixture()
      update_attrs = %{currency: "some updated currency", destiny: "some updated destiny", id: 43, owner: "some updated owner", time: ~U[2022-04-15 22:59:00Z], value: "456.7"}

      assert {:ok, %Money{} = money} = Transactions.update_money(money, update_attrs)
      assert money.currency == "some updated currency"
      assert money.destiny == "some updated destiny"
      assert money.id == 43
      assert money.owner == "some updated owner"
      assert money.time == ~U[2022-04-15 22:59:00Z]
      assert money.value == Decimal.new("456.7")
    end

    test "update_money/2 with invalid data returns error changeset" do
      money = money_fixture()
      assert {:error, %Ecto.Changeset{}} = Transactions.update_money(money, @invalid_attrs)
      assert money == Transactions.get_money!(money.id)
    end

    test "delete_money/1 deletes the money" do
      money = money_fixture()
      assert {:ok, %Money{}} = Transactions.delete_money(money)
      assert_raise Ecto.NoResultsError, fn -> Transactions.get_money!(money.id) end
    end

    test "change_money/1 returns a money changeset" do
      money = money_fixture()
      assert %Ecto.Changeset{} = Transactions.change_money(money)
    end
  end
end
