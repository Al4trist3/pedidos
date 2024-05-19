defmodule PedidosWeb.OrdenController do
  use PedidosWeb, :controller

  alias Pedidos.Ordenes

  def create(conn, _) do
    case Ordenes.complete_orden(conn.assigns.carrito) do
      {:ok, orden} ->
        conn
        |> put_flash(:info, "Pedido creado Satisfactoriamente.")
        |> redirect(to: ~p"/ordenes/#{orden}")

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Hubo un error al procesar el pedido")
        |> redirect(to: ~p"/carrito")
    end
  end

  def show(conn, %{"id" => id}) do
    orden = Ordenes.get_orden!(conn.assigns.current_uuid, id)
    render(conn, :show, orden: orden)
  end
end
