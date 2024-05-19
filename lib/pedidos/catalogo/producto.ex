defmodule Pedidos.Catalogo.Producto do
  use Ecto.Schema
  import Ecto.Changeset

  schema "productos" do
    field :titulo, :string
    field :stock, :integer
    field :precio, :decimal

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(producto, attrs) do
    producto
    |> cast(attrs, [:titulo, :stock, :precio])
    |> validate_required([:titulo, :stock, :precio])
    |> validate_number(:stock, greater_than_or_equal_to: 0)
  end
end
