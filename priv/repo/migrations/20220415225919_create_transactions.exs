defmodule Verdinho.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :owner, :string
      add :destiny, :string
      add :value, :decimal
      add :time, :utc_datetime
      add :currency, :string

      timestamps()
    end
  end
end
