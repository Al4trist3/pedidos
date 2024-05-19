defmodule Pedidos.OrdenesTest do
  use Pedidos.DataCase

  alias Pedidos.Ordenes

  describe "ordenes" do
    alias Pedidos.Ordenes.Orden

    import Pedidos.OrdenesFixtures

    @invalid_attrs %{user_uuid: nil, precio_total: nil}

    test "list_ordenes/0 returns all ordenes" do
      orden = orden_fixture()
      assert Ordenes.list_ordenes() == [orden]
    end

    test "get_orden!/1 returns the orden with given id" do
      orden = orden_fixture()
      assert Ordenes.get_orden!(orden.id) == orden
    end

    test "create_orden/1 with valid data creates a orden" do
      valid_attrs = %{user_uuid: "7488a646-e31f-11e4-aace-600308960662", precio_total: "120.5"}

      assert {:ok, %Orden{} = orden} = Ordenes.create_orden(valid_attrs)
      assert orden.user_uuid == "7488a646-e31f-11e4-aace-600308960662"
      assert orden.precio_total == Decimal.new("120.5")
    end

    test "create_orden/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Ordenes.create_orden(@invalid_attrs)
    end

    test "update_orden/2 with valid data updates the orden" do
      orden = orden_fixture()
      update_attrs = %{user_uuid: "7488a646-e31f-11e4-aace-600308960668", precio_total: "456.7"}

      assert {:ok, %Orden{} = orden} = Ordenes.update_orden(orden, update_attrs)
      assert orden.user_uuid == "7488a646-e31f-11e4-aace-600308960668"
      assert orden.precio_total == Decimal.new("456.7")
    end

    test "update_orden/2 with invalid data returns error changeset" do
      orden = orden_fixture()
      assert {:error, %Ecto.Changeset{}} = Ordenes.update_orden(orden, @invalid_attrs)
      assert orden == Ordenes.get_orden!(orden.id)
    end

    test "delete_orden/1 deletes the orden" do
      orden = orden_fixture()
      assert {:ok, %Orden{}} = Ordenes.delete_orden(orden)
      assert_raise Ecto.NoResultsError, fn -> Ordenes.get_orden!(orden.id) end
    end

    test "change_orden/1 returns a orden changeset" do
      orden = orden_fixture()
      assert %Ecto.Changeset{} = Ordenes.change_orden(orden)
    end
  end

  describe "orden_linea_items" do
    alias Pedidos.Ordenes.LineaItem

    import Pedidos.OrdenesFixtures

    @invalid_attrs %{precio: nil, cantidad: nil}

    test "list_orden_linea_items/0 returns all orden_linea_items" do
      linea_item = linea_item_fixture()
      assert Ordenes.list_orden_linea_items() == [linea_item]
    end

    test "get_linea_item!/1 returns the linea_item with given id" do
      linea_item = linea_item_fixture()
      assert Ordenes.get_linea_item!(linea_item.id) == linea_item
    end

    test "create_linea_item/1 with valid data creates a linea_item" do
      valid_attrs = %{precio: "120.5", cantidad: 42}

      assert {:ok, %LineaItem{} = linea_item} = Ordenes.create_linea_item(valid_attrs)
      assert linea_item.precio == Decimal.new("120.5")
      assert linea_item.cantidad == 42
    end

    test "create_linea_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Ordenes.create_linea_item(@invalid_attrs)
    end

    test "update_linea_item/2 with valid data updates the linea_item" do
      linea_item = linea_item_fixture()
      update_attrs = %{precio: "456.7", cantidad: 43}

      assert {:ok, %LineaItem{} = linea_item} = Ordenes.update_linea_item(linea_item, update_attrs)
      assert linea_item.precio == Decimal.new("456.7")
      assert linea_item.cantidad == 43
    end

    test "update_linea_item/2 with invalid data returns error changeset" do
      linea_item = linea_item_fixture()
      assert {:error, %Ecto.Changeset{}} = Ordenes.update_linea_item(linea_item, @invalid_attrs)
      assert linea_item == Ordenes.get_linea_item!(linea_item.id)
    end

    test "delete_linea_item/1 deletes the linea_item" do
      linea_item = linea_item_fixture()
      assert {:ok, %LineaItem{}} = Ordenes.delete_linea_item(linea_item)
      assert_raise Ecto.NoResultsError, fn -> Ordenes.get_linea_item!(linea_item.id) end
    end

    test "change_linea_item/1 returns a linea_item changeset" do
      linea_item = linea_item_fixture()
      assert %Ecto.Changeset{} = Ordenes.change_linea_item(linea_item)
    end
  end
end
