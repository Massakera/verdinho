defmodule Verdinho.Transactions.Money do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :currency, :string
    field :destiny, :string
    field :owner, :string
    field :time, :utc_datetime
    field :value, :decimal

    timestamps()
  end

  @doc false
  def changeset(money, attrs) do
    money
    |> cast(attrs, [:id, :owner, :destiny, :value, :time, :currency])
    |> validate_required([:id, :owner, :destiny, :value, :time, :currency])
  end
end
