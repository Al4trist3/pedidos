defmodule PedidosWeb.CarritoController do
  use PedidosWeb, :controller

  alias Pedidos.CarritoDeCompras

  def show(conn, _params) do
    render(conn, :show, changeset: CarritoDeCompras.change_carrito(conn.assigns.carrito))
  end

  def update(conn, %{"carrito" => carrito_params}) do
    case CarritoDeCompras.update_carrito(conn.assigns.carrito, carrito_params) do
      {:ok, _cart} ->
        redirect(conn, to: ~p"/carrito")

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Hubo un error actualizando tu carrito")
        |> redirect(to: ~p"/carrito")
    end
  end
end
