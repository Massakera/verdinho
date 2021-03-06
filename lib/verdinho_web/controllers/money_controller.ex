defmodule VerdinhoWeb.MoneyController do
  use VerdinhoWeb, :controller

  alias Verdinho.Transactions
  alias Verdinho.Transactions.Money

  def index(conn, _params) do
    transactions = Transactions.list_transactions()
    render(conn, "index.html", transactions: transactions)
  end

  def new(conn, _params) do
    changeset = Transactions.change_money(%Money{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"money" => money_params}) do
    case Transactions.create_money(money_params) do
      {:ok, money} ->
        conn
        |> put_flash(:info, "Money created successfully.")
        |> redirect(to: Routes.money_path(conn, :show, money))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    money = Transactions.get_money!(id)
    render(conn, "show.html", money: money)
  end

  def edit(conn, %{"id" => id}) do
    money = Transactions.get_money!(id)
    changeset = Transactions.change_money(money)
    render(conn, "edit.html", money: money, changeset: changeset)
  end

  def update(conn, %{"id" => id, "money" => money_params}) do
    money = Transactions.get_money!(id)

    case Transactions.update_money(money, money_params) do
      {:ok, money} ->
        conn
        |> put_flash(:info, "Money updated successfully.")
        |> redirect(to: Routes.money_path(conn, :show, money))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", money: money, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    money = Transactions.get_money!(id)
    {:ok, _money} = Transactions.delete_money(money)

    conn
    |> put_flash(:info, "Money deleted successfully.")
    |> redirect(to: Routes.money_path(conn, :index))
  end

  def import(conn, %{"csv" => csv}) do
    data = csv_decoder(csv)
    result = import_transactions(data)

    conn
    |> put_flash(:info, "Transaction imported successfully.")
    |> redirect(to: Routes.money_path(conn, :index))
  end

  defp import_transactions(data) do
    transactions = Enum.map(data, fn {:ok, transaction} -> parse(transaction) end)
    params = Transactions.convert_params(transactions)

    {_, _} = Transactions.insert_transactions(params)
  end

  defp csv_decoder(file) do
    csv =
      "#(file.path)"
      |> Path.expand(__DIR__)
      |> File.stream!()
      |> CSV.decode(headers: true)
      |> Enum.map(fn data -> data end)
  end

  defp import_transactions(data) do
    transactions = Enum.map(data, fn (:ok, transaction) -> parse(transaction) end)

    params = Transactions.convert_params(transactions)

    {_, _}= Transactions.insert_transactions(params)
  end

  defp parse(transaction) do
    fields = Transactions.parse_field(transaction)
  end

#=== INSERT ALL ====
  def insert_transaction(items) do
    Transaction
    |> Repo.insert_all(items,
    on_conflict: :nothing,
    returning: true
    )
  end
end
