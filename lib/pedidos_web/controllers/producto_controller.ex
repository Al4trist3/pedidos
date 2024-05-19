defmodule PedidosWeb.ProductoController do
  use PedidosWeb, :controller

  alias Pedidos.Catalogo
  alias Pedidos.Catalogo.Producto

  def index(conn, _params) do
    productos = Catalogo.list_productos()
    render(conn, :index, productos: productos)
  end

  def new(conn, _params) do
    changeset = Catalogo.change_producto(%Producto{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"producto" => producto_params}) do
    case Catalogo.create_producto(producto_params) do
      {:ok, producto} ->
        conn
        |> put_flash(:info, "Producto creado satisfactoriamente.")
        |> redirect(to: ~p"/productos/#{producto}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    producto = Catalogo.get_producto!(id)
    render(conn, :show, producto: producto)
  end

  def edit(conn, %{"id" => id}) do
    producto = Catalogo.get_producto!(id)
    changeset = Catalogo.change_producto(producto)
    render(conn, :edit, producto: producto, changeset: changeset)
  end

  def update(conn, %{"id" => id, "producto" => producto_params}) do
    producto = Catalogo.get_producto!(id)

    case Catalogo.update_producto(producto, producto_params) do
      {:ok, producto} ->
        conn
        |> put_flash(:info, "Producto modificado satisfactoriamente.")
        |> redirect(to: ~p"/productos/#{producto}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, producto: producto, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    producto = Catalogo.get_producto!(id)
    {:ok, _producto} = Catalogo.delete_producto(producto)

    conn
    |> put_flash(:info, "Producto borrado satisfactoriamente.")
    |> redirect(to: ~p"/productos")
  end
end
