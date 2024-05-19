defmodule Pedidos.CarritoDeCompras.CarritoItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "carrito_items" do
    field :precio_en_carrito, :decimal
    field :cantidad, :integer
    belongs_to :carrito, Pedidos.CarritoDeCompras.Carrito
    belongs_to :producto, Pedidos.Catalogo.Producto


    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(carrito_item, attrs) do
    carrito_item
    |> cast(attrs, [:precio_en_carrito, :cantidad])
    |> validate_required([:precio_en_carrito, :cantidad])
    |> validate_number(:cantidad, greater_than_or_equal_to: 0, less_than: 100)
  end
end
