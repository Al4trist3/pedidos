defmodule PedidosWeb.CarritoItemController do
  use PedidosWeb, :controller

  alias Pedidos.CarritoDeCompras

  def create(conn, %{"producto_id" => producto_id}) do
    case CarritoDeCompras.add_item_to_cart(conn.assigns.carrito, producto_id) do
      {:ok, _item} ->
        conn
        |> put_flash(:info, "Item agregado al carrito")
        |> redirect(to: ~p"/carrito")

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Hubo un error al intentar agregar el item al carrito")
        |> redirect(to: ~p"/carrito")
    end
  end

  def delete(conn, %{"id" => producto_id}) do
    {:ok, _cart} = CarritoDeCompras.remove_item_from_cart(conn.assigns.cart, producto_id)
    redirect(conn, to: ~p"/carrito")
  end
end
