defmodule Pedidos.CatalogoTest do
  use Pedidos.DataCase

  alias Pedidos.Catalogo

  describe "productos" do
    alias Pedidos.Catalogo.Producto

    import Pedidos.CatalogoFixtures

    @invalid_attrs %{titulo: nil, stock: nil, precio: nil}

    test "list_productos/0 returns all productos" do
      producto = producto_fixture()
      assert Catalogo.list_productos() == [producto]
    end

    test "get_producto!/1 returns the producto with given id" do
      producto = producto_fixture()
      assert Catalogo.get_producto!(producto.id) == producto
    end

    test "create_producto/1 with valid data creates a producto" do
      valid_attrs = %{titulo: "some titulo", stock: 42, precio: "120.5"}

      assert {:ok, %Producto{} = producto} = Catalogo.create_producto(valid_attrs)
      assert producto.titulo == "some titulo"
      assert producto.stock == 42
      assert producto.precio == Decimal.new("120.5")
    end

    test "create_producto/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalogo.create_producto(@invalid_attrs)
    end

    test "update_producto/2 with valid data updates the producto" do
      producto = producto_fixture()
      update_attrs = %{titulo: "some updated titulo", stock: 43, precio: "456.7"}

      assert {:ok, %Producto{} = producto} = Catalogo.update_producto(producto, update_attrs)
      assert producto.titulo == "some updated titulo"
      assert producto.stock == 43
      assert producto.precio == Decimal.new("456.7")
    end

    test "update_producto/2 with invalid data returns error changeset" do
      producto = producto_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalogo.update_producto(producto, @invalid_attrs)
      assert producto == Catalogo.get_producto!(producto.id)
    end

    test "delete_producto/1 deletes the producto" do
      producto = producto_fixture()
      assert {:ok, %Producto{}} = Catalogo.delete_producto(producto)
      assert_raise Ecto.NoResultsError, fn -> Catalogo.get_producto!(producto.id) end
    end

    test "change_producto/1 returns a producto changeset" do
      producto = producto_fixture()
      assert %Ecto.Changeset{} = Catalogo.change_producto(producto)
    end
  end
end
