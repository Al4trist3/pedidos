defmodule Pedidos.Ordenes do
  @moduledoc """
  The Ordenes context.
  """

  import Ecto.Query, warn: false
  alias Pedidos.CarritoDeCompras
  alias Pedidos.Repo

  alias Pedidos.Ordenes.Orden

  @doc """
  Returns the list of ordenes.

  ## Examples

      iex> list_ordenes()
      [%Orden{}, ...]

  """
  def list_ordenes do
    Repo.all(Orden)
  end

  @doc """
  Gets a single orden.

  Raises `Ecto.NoResultsError` if the Orden does not exist.

  ## Examples

      iex> get_orden!(123)
      %Orden{}

      iex> get_orden!(456)
      ** (Ecto.NoResultsError)

  """
    def get_orden!(user_uuid, id) do
      Orden
      |> Repo.get_by!(id: id, user_uuid: user_uuid)
      |> Repo.preload([linea_items: [:producto]])
    end


    alias Pedidos.Ordenes.LineaItem
    alias Pedidos.CarritoDeCompras
    alias Pedidos.Catalogo

    def complete_orden(%CarritoDeCompras.Carrito{} = carrito) do
      linea_items =
        Enum.map(carrito.items, fn item ->
          %{producto_id: item.producto_id, precio: item.producto.precio, cantidad: item.cantidad}
        end)

      orden =
        Ecto.Changeset.change(%Orden{},
          user_uuid: carrito.user_uuid,
          precio_total: CarritoDeCompras.total_cart_price(carrito),
          linea_items: linea_items
        )

      Ecto.Multi.new()
      |> Ecto.Multi.insert(:orden, orden)
      |> Ecto.Multi.run(:prune_carrito, fn _repo, _changes ->
        CarritoDeCompras.prune_cart_items(carrito)
      end)
      |> Ecto.Multi.run(:update_stocks, fn _repo, _changes ->
        Catalogo.update_stocks(linea_items)
      end)
      |> Repo.transaction()
      |> case do
        {:ok, %{orden: orden}} -> {:ok, orden}
        {:error, name, value, _changes_so_far} -> {:error, {name, value}}
      end
    end

  @doc """
  Creates a orden.

  ## Examples

      iex> create_orden(%{field: value})
      {:ok, %Orden{}}

      iex> create_orden(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_orden(attrs \\ %{}) do
    %Orden{}
    |> Orden.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a orden.

  ## Examples

      iex> update_orden(orden, %{field: new_value})
      {:ok, %Orden{}}

      iex> update_orden(orden, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_orden(%Orden{} = orden, attrs) do
    orden
    |> Orden.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a orden.

  ## Examples

      iex> delete_orden(orden)
      {:ok, %Orden{}}

      iex> delete_orden(orden)
      {:error, %Ecto.Changeset{}}

  """
  def delete_orden(%Orden{} = orden) do
    Repo.delete(orden)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking orden changes.

  ## Examples

      iex> change_orden(orden)
      %Ecto.Changeset{data: %Orden{}}

  """
  def change_orden(%Orden{} = orden, attrs \\ %{}) do
    Orden.changeset(orden, attrs)
  end

  alias Pedidos.Ordenes.LineaItem

  @doc """
  Returns the list of orden_linea_items.

  ## Examples

      iex> list_orden_linea_items()
      [%LineaItem{}, ...]

  """
  def list_orden_linea_items do
    Repo.all(LineaItem)
  end

  @doc """
  Gets a single linea_item.

  Raises `Ecto.NoResultsError` if the Linea item does not exist.

  ## Examples

      iex> get_linea_item!(123)
      %LineaItem{}

      iex> get_linea_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_linea_item!(id), do: Repo.get!(LineaItem, id)

  @doc """
  Creates a linea_item.

  ## Examples

      iex> create_linea_item(%{field: value})
      {:ok, %LineaItem{}}

      iex> create_linea_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_linea_item(attrs \\ %{}) do
    %LineaItem{}
    |> LineaItem.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a linea_item.

  ## Examples

      iex> update_linea_item(linea_item, %{field: new_value})
      {:ok, %LineaItem{}}

      iex> update_linea_item(linea_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_linea_item(%LineaItem{} = linea_item, attrs) do
    linea_item
    |> LineaItem.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a linea_item.

  ## Examples

      iex> delete_linea_item(linea_item)
      {:ok, %LineaItem{}}

      iex> delete_linea_item(linea_item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_linea_item(%LineaItem{} = linea_item) do
    Repo.delete(linea_item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking linea_item changes.

  ## Examples

      iex> change_linea_item(linea_item)
      %Ecto.Changeset{data: %LineaItem{}}

  """
  def change_linea_item(%LineaItem{} = linea_item, attrs \\ %{}) do
    LineaItem.changeset(linea_item, attrs)
  end
end
