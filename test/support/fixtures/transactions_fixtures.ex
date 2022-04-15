defmodule Verdinho.TransactionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Verdinho.Transactions` context.
  """

  @doc """
  Generate a money.
  """
  def money_fixture(attrs \\ %{}) do
    {:ok, money} =
      attrs
      |> Enum.into(%{
        currency: "some currency",
        destiny: "some destiny",
        id: 42,
        owner: "some owner",
        time: ~U[2022-04-14 22:59:00Z],
        value: "120.5"
      })
      |> Verdinho.Transactions.create_money()

    money
  end
end
