defmodule Pedidos.Repo.Migrations.CreateCarritoItems do
  use Ecto.Migration

  def change do
    create table(:carrito_items) do
      add :precio_en_carrito, :decimal, precision: 15, scale: 6, null: false
      add :cantidad, :integer
      add :carrito_id, references(:carritos, on_delete: :delete_all)
      add :producto_id, references(:productos, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:carrito_items, [:carrito_id])
    create unique_index(:carrito_items, [:carrito_id, :producto_id])
  end
end
