defmodule Verdinho.Repo do
  use Ecto.Repo,
    otp_app: :verdinho,
    adapter: Ecto.Adapters.Postgres
end
