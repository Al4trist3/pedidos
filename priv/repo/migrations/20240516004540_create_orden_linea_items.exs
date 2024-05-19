defmodule Pedidos.Repo.Migrations.CreateOrdenLineaItems do
  use Ecto.Migration

  def change do
    create table(:orden_linea_items) do
      add :precio, :decimal, precision: 15, scale: 6, null: false
      add :cantidad, :integer
      add :orden_id, references(:ordenes, on_delete: :nothing)
      add :producto_id, references(:productos, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:orden_linea_items, [:orden_id])
    create index(:orden_linea_items, [:producto_id])
  end
end
