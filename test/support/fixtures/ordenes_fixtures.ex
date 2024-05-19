defmodule Pedidos.OrdenesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pedidos.Ordenes` context.
  """

  @doc """
  Generate a orden.
  """
  def orden_fixture(attrs \\ %{}) do
    {:ok, orden} =
      attrs
      |> Enum.into(%{
        precio_total: "120.5",
        user_uuid: "7488a646-e31f-11e4-aace-600308960662"
      })
      |> Pedidos.Ordenes.create_orden()

    orden
  end

  @doc """
  Generate a linea_item.
  """
  def linea_item_fixture(attrs \\ %{}) do
    {:ok, linea_item} =
      attrs
      |> Enum.into(%{
        cantidad: 42,
        precio: "120.5"
      })
      |> Pedidos.Ordenes.create_linea_item()

    linea_item
  end
end
