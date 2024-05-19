defmodule Pedidos.CarritoDeComprasTest do
  use Pedidos.DataCase

  alias Pedidos.CarritoDeCompras

  describe "carritos" do
    alias Pedidos.CarritoDeCompras.Carrito

    import Pedidos.CarritoDeComprasFixtures

    @invalid_attrs %{user_uuid: nil}

    test "list_carritos/0 returns all carritos" do
      carrito = carrito_fixture()
      assert CarritoDeCompras.list_carritos() == [carrito]
    end

    test "get_carrito!/1 returns the carrito with given id" do
      carrito = carrito_fixture()
      assert CarritoDeCompras.get_carrito!(carrito.id) == carrito
    end

    test "create_carrito/1 with valid data creates a carrito" do
      valid_attrs = %{user_uuid: "7488a646-e31f-11e4-aace-600308960662"}

      assert {:ok, %Carrito{} = carrito} = CarritoDeCompras.create_carrito(valid_attrs)
      assert carrito.user_uuid == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "create_carrito/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CarritoDeCompras.create_carrito(@invalid_attrs)
    end

    test "update_carrito/2 with valid data updates the carrito" do
      carrito = carrito_fixture()
      update_attrs = %{user_uuid: "7488a646-e31f-11e4-aace-600308960668"}

      assert {:ok, %Carrito{} = carrito} = CarritoDeCompras.update_carrito(carrito, update_attrs)
      assert carrito.user_uuid == "7488a646-e31f-11e4-aace-600308960668"
    end

    test "update_carrito/2 with invalid data returns error changeset" do
      carrito = carrito_fixture()
      assert {:error, %Ecto.Changeset{}} = CarritoDeCompras.update_carrito(carrito, @invalid_attrs)
      assert carrito == CarritoDeCompras.get_carrito!(carrito.id)
    end

    test "delete_carrito/1 deletes the carrito" do
      carrito = carrito_fixture()
      assert {:ok, %Carrito{}} = CarritoDeCompras.delete_carrito(carrito)
      assert_raise Ecto.NoResultsError, fn -> CarritoDeCompras.get_carrito!(carrito.id) end
    end

    test "change_carrito/1 returns a carrito changeset" do
      carrito = carrito_fixture()
      assert %Ecto.Changeset{} = CarritoDeCompras.change_carrito(carrito)
    end
  end

  describe "carrito_items" do
    alias Pedidos.CarritoDeCompras.CarritoItem

    import Pedidos.CarritoDeComprasFixtures

    @invalid_attrs %{precio_en_carrito: nil, cantidad: nil}

    test "list_carrito_items/0 returns all carrito_items" do
      carrito_item = carrito_item_fixture()
      assert CarritoDeCompras.list_carrito_items() == [carrito_item]
    end

    test "get_carrito_item!/1 returns the carrito_item with given id" do
      carrito_item = carrito_item_fixture()
      assert CarritoDeCompras.get_carrito_item!(carrito_item.id) == carrito_item
    end

    test "create_carrito_item/1 with valid data creates a carrito_item" do
      valid_attrs = %{precio_en_carrito: "120.5", cantidad: 42}

      assert {:ok, %CarritoItem{} = carrito_item} = CarritoDeCompras.create_carrito_item(valid_attrs)
      assert carrito_item.precio_en_carrito == Decimal.new("120.5")
      assert carrito_item.cantidad == 42
    end

    test "create_carrito_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CarritoDeCompras.create_carrito_item(@invalid_attrs)
    end

    test "update_carrito_item/2 with valid data updates the carrito_item" do
      carrito_item = carrito_item_fixture()
      update_attrs = %{precio_en_carrito: "456.7", cantidad: 43}

      assert {:ok, %CarritoItem{} = carrito_item} = CarritoDeCompras.update_carrito_item(carrito_item, update_attrs)
      assert carrito_item.precio_en_carrito == Decimal.new("456.7")
      assert carrito_item.cantidad == 43
    end

    test "update_carrito_item/2 with invalid data returns error changeset" do
      carrito_item = carrito_item_fixture()
      assert {:error, %Ecto.Changeset{}} = CarritoDeCompras.update_carrito_item(carrito_item, @invalid_attrs)
      assert carrito_item == CarritoDeCompras.get_carrito_item!(carrito_item.id)
    end

    test "delete_carrito_item/1 deletes the carrito_item" do
      carrito_item = carrito_item_fixture()
      assert {:ok, %CarritoItem{}} = CarritoDeCompras.delete_carrito_item(carrito_item)
      assert_raise Ecto.NoResultsError, fn -> CarritoDeCompras.get_carrito_item!(carrito_item.id) end
    end

    test "change_carrito_item/1 returns a carrito_item changeset" do
      carrito_item = carrito_item_fixture()
      assert %Ecto.Changeset{} = CarritoDeCompras.change_carrito_item(carrito_item)
    end
  end
end
