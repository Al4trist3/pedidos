defmodule Pedidos.Repo.Migrations.CreateProductos do
  use Ecto.Migration

  def change do
    create table(:productos) do
      add :titulo, :string
      add :stock, :integer, null: false
      add :precio, :decimal, precision: 15, scale: 6, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
