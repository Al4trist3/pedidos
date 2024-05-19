defmodule Pedidos.CatalogoFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pedidos.Catalogo` context.
  """

  @doc """
  Generate a producto.
  """
  def producto_fixture(attrs \\ %{}) do
    {:ok, producto} =
      attrs
      |> Enum.into(%{
        precio: "120.5",
        stock: 42,
        titulo: "some titulo"
      })
      |> Pedidos.Catalogo.create_producto()

    producto
  end
end
