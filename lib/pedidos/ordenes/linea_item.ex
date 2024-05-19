defmodule Pedidos.Ordenes.LineaItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orden_linea_items" do
    field :precio, :decimal
    field :cantidad, :integer
    belongs_to :orden, Pedidos.Ordenes.Orden
    belongs_to :producto, Pedidos.Catalogo.Producto

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(linea_item, attrs) do
    linea_item
    |> cast(attrs, [:precio, :cantidad])
    |> validate_required([:precio, :cantidad])
  end
end
