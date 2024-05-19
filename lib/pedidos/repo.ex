defmodule Pedidos.Repo do
  use Ecto.Repo,
    otp_app: :pedidos,
    adapter: Ecto.Adapters.Postgres
end
