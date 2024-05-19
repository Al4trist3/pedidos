defmodule Pedidos.CarritoDeCompras.Carrito do
  use Ecto.Schema
  import Ecto.Changeset

  schema "carritos" do
    field :user_uuid, Ecto.UUID

    has_many :items, Pedidos.CarritoDeCompras.CarritoItem

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(carrito, attrs) do
    carrito
    |> cast(attrs, [:user_uuid])
    |> validate_required([:user_uuid])
    |> unique_constraint(:user_uuid)
  end
end
