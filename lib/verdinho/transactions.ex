defmodule Verdinho.Transactions do
  @moduledoc """
  The Transactions context.
  """

  import Ecto.Query, warn: false
  alias Verdinho.Repo

  alias Verdinho.Transactions.Money

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_transactions()
      [%Money{}, ...]

  """
  def list_transactions do
    Repo.all(Money)
  end

  @doc """
  Gets a single money.

  Raises `Ecto.NoResultsError` if the Money does not exist.

  ## Examples

      iex> get_money!(123)
      %Money{}

      iex> get_money!(456)
      ** (Ecto.NoResultsError)

  """
  def get_money!(id), do: Repo.get!(Money, id)

  @doc """
  Creates a money.

  ## Examples

      iex> create_money(%{field: value})
      {:ok, %Money{}}

      iex> create_money(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_money(attrs \\ %{}) do
    %Money{}
    |> Money.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a money.

  ## Examples

      iex> update_money(money, %{field: new_value})
      {:ok, %Money{}}

      iex> update_money(money, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_money(%Money{} = money, attrs) do
    money
    |> Money.changeset(attrs)
    |> Repo.update()
  end


  @doc """
  Deletes a money.

  ## Examples

      iex> delete_money(money)
      {:ok, %Money{}}

      iex> delete_money(money)
      {:error, %Ecto.Changeset{}}

  """
  def delete_money(%Money{} = money) do
    Repo.delete(money)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking money changes.

  ## Examples

      iex> change_money(money)
      %Ecto.Changeset{data: %Money{}}

  """
  def change_money(%Money{} = money, attrs \\ %{}) do
    Money.changeset(money, attrs)
  end

  def convert_params(data) do
    data
    |> Enum.map(fn transactions ->
      transactions
      |> Enum.map(fn transaction -> transaction end)
      |> Enum.map(fn {key, value} -> {key, value} end)
      |> Enum.into(%{})
      |> convert()
    end)
  end

  def convert(data) do
    for {key, val} <- data, into: %{}, do: {String.to_atom(key), val}
  end

  def parse_field(transaction) do
    timestamp =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.truncate(:second)

    transaction
    |> Map.put("inserted_at", timestamp)
    |> Map.put("updated_at", timestamp)
  end

  defp csv_decoder(file) do
    csv =
      "#{file.path}"
      |> Path.expand(__DIR__)
      |> File.stream!()
      |> CSV.decode(headers: true)
      |> Enum.map(fn data -> data end)
  end

# IMPORT TRANSACTIONS ---->

  defp import_transactions(data) do
    transactions = Enum.map(data, fn {:ok, transaction} -> parse(transaction) end)

    params = Transactions.convert_params(transactions)

    {_, _} = Transactions.insert_transaction(params)
  end

  defp parse(transaction) do
    fields = Transactions.parse_fields(transaction)
  end
end
