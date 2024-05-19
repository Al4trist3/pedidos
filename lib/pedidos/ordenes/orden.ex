defmodule Pedidos.Ordenes.Orden do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ordenes" do
    field :user_uuid, Ecto.UUID
    field :precio_total, :decimal

    has_many :linea_items, Pedidos.Ordenes.LineaItem
    has_many :productos, through: [:linea_items, :producto]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(orden, attrs) do
    orden
    |> cast(attrs, [:user_uuid, :precio_total])
    |> validate_required([:user_uuid, :precio_total])
  end
end
