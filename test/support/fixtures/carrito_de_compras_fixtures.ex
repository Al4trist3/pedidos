defmodule Pedidos.CarritoDeComprasFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pedidos.CarritoDeCompras` context.
  """

  @doc """
  Generate a unique carrito user_uuid.
  """
  def unique_carrito_user_uuid do
    raise "implement the logic to generate a unique carrito user_uuid"
  end

  @doc """
  Generate a carrito.
  """
  def carrito_fixture(attrs \\ %{}) do
    {:ok, carrito} =
      attrs
      |> Enum.into(%{
        user_uuid: unique_carrito_user_uuid()
      })
      |> Pedidos.CarritoDeCompras.create_carrito()

    carrito
  end

  @doc """
  Generate a carrito_item.
  """
  def carrito_item_fixture(attrs \\ %{}) do
    {:ok, carrito_item} =
      attrs
      |> Enum.into(%{
        cantidad: 42,
        precio_en_carrito: "120.5"
      })
      |> Pedidos.CarritoDeCompras.create_carrito_item()

    carrito_item
  end
end
