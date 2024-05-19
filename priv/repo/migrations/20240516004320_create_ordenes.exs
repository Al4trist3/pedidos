defmodule Pedidos.Repo.Migrations.CreateOrdenes do
  use Ecto.Migration

  def change do
    create table(:ordenes) do
      add :user_uuid, :uuid
      add :precio_total, :decimal, precision: 15, scale: 6, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
