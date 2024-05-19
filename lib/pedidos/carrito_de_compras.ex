defmodule Pedidos.CarritoDeCompras do
  @moduledoc """
  The CarritoDeCompras context.
  """

  import Ecto.Query, warn: false
  alias Pedidos.Repo
  alias Pedidos.Catalogo
  alias Pedidos.CarritoDeCompras.{Carrito, CarritoItem}

  @doc """
  Returns the list of carritos.

  ## Examples

      iex> list_carritos()
      [%Carrito{}, ...]

  """
  def list_carritos do
    Repo.all(Carrito)
  end

  @doc """
  Gets a single carrito.

  Raises `Ecto.NoResultsError` if the Carrito does not exist.

  ## Examples

      iex> get_carrito!(123)
      %Carrito{}

      iex> get_carrito!(456)
      ** (Ecto.NoResultsError)

  """
  def get_carrito!(id), do: Repo.get!(Carrito, id)

  @doc """
  Creates a carrito.

  ## Examples

      iex> create_carrito(%{field: value})
      {:ok, %Carrito{}}

      iex> create_carrito(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_carrito(user_uuid) do
    %Carrito{user_uuid: user_uuid}
    |> Carrito.changeset(%{})
    |> Repo.insert()
    |> case do
      {:ok, cart} -> {:ok, reload_carrito(cart)}
      {:error, changeset} -> {:error, changeset}
    end
  end

  defp reload_carrito(%Carrito{} = carrito), do: get_cart_by_user_uuid(carrito.user_uuid)

  def add_item_to_cart(%Carrito{} = carrito, producto_id) do
        producto = Catalogo.get_producto!(producto_id)

        %CarritoItem{cantidad: 1, precio_en_carrito: producto.precio}
        |> CarritoItem.changeset(%{})
        |> Ecto.Changeset.put_assoc(:carrito, carrito)
        |> Ecto.Changeset.put_assoc(:producto, producto)
        |> Repo.insert(
          on_conflict: [inc: [cantidad: 1]],
          conflict_target: [:carrito_id, :producto_id]
        )
  end

  def remove_item_from_cart(%Carrito{} = carrito, producto_id) do
        {1, _} =
          Repo.delete_all(
            from(i in CarritoItem,
              where: i.carrito_id == ^carrito.id,
              where: i.producto_id == ^producto_id
            )
          )

        {:ok, reload_carrito(carrito)}
  end

  @doc """
  Updates a carrito.

  ## Examples

      iex> update_carrito(carrito, %{field: new_value})
      {:ok, %Carrito{}}

      iex> update_carrito(carrito, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_carrito(%Carrito{} = carrito, attrs) do
    changeset =
      carrito
      |> Carrito.changeset(attrs)
      |> Ecto.Changeset.cast_assoc(:items, with: &CarritoItem.changeset/2)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:carrito, changeset)
    |> Ecto.Multi.delete_all(:discarded_items, fn %{carrito: carrito} ->
      from(i in CarritoItem, where: i.carrito_id == ^carrito.id and i.cantidad == 0)
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{carrito: carrito}} -> {:ok, carrito}
      {:error, :carrito, changeset, _changes_so_far} -> {:error, changeset}
    end
  end

  @doc """
  Deletes a carrito.

  ## Examples

      iex> delete_carrito(carrito)
      {:ok, %Carrito{}}

      iex> delete_carrito(carrito)
      {:error, %Ecto.Changeset{}}

  """
  def delete_carrito(%Carrito{} = carrito) do
    Repo.delete(carrito)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking carrito changes.

  ## Examples

      iex> change_carrito(carrito)
      %Ecto.Changeset{data: %Carrito{}}

  """
  def change_carrito(%Carrito{} = carrito, attrs \\ %{}) do
    Carrito.changeset(carrito, attrs)
  end

  alias Pedidos.CarritoDeCompras.CarritoItem

  @doc """
  Returns the list of carrito_items.

  ## Examples

      iex> list_carrito_items()
      [%CarritoItem{}, ...]

  """
  def list_carrito_items do
    Repo.all(CarritoItem)
  end

  @doc """
  Gets a single carrito_item.

  Raises `Ecto.NoResultsError` if the Carrito item does not exist.

  ## Examples

      iex> get_carrito_item!(123)
      %CarritoItem{}

      iex> get_carrito_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_carrito_item!(id), do: Repo.get!(CarritoItem, id)

  @doc """
  Creates a carrito_item.

  ## Examples

      iex> create_carrito_item(%{field: value})
      {:ok, %CarritoItem{}}

      iex> create_carrito_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_carrito_item(attrs \\ %{}) do
    %CarritoItem{}
    |> CarritoItem.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a carrito_item.

  ## Examples

      iex> update_carrito_item(carrito_item, %{field: new_value})
      {:ok, %CarritoItem{}}

      iex> update_carrito_item(carrito_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_carrito_item(%CarritoItem{} = carrito_item, attrs) do
    carrito_item
    |> CarritoItem.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a carrito_item.

  ## Examples

      iex> delete_carrito_item(carrito_item)
      {:ok, %CarritoItem{}}

      iex> delete_carrito_item(carrito_item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_carrito_item(%CarritoItem{} = carrito_item) do
    Repo.delete(carrito_item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking carrito_item changes.

  ## Examples

      iex> change_carrito_item(carrito_item)
      %Ecto.Changeset{data: %CarritoItem{}}

  """
  def change_carrito_item(%CarritoItem{} = carrito_item, attrs \\ %{}) do
    CarritoItem.changeset(carrito_item, attrs)
  end

  def get_cart_by_user_uuid(user_uuid) do
        Repo.one(
          from(c in Carrito,
            where: c.user_uuid == ^user_uuid,
            left_join: i in assoc(c, :items),
            left_join: p in assoc(i, :producto),
            order_by: [asc: i.inserted_at],
            preload: [items: {i, producto: p}]
          )
        )
  end


  def total_item_price(%CarritoItem{} = item) do
    Decimal.mult(item.producto.precio, item.cantidad)
  end

  def total_cart_price(%Carrito{} = carrito) do
    Enum.reduce(carrito.items, 0, fn item, acc ->
      item
      |> total_item_price()
      |> Decimal.add(acc)
    end)
  end

  def prune_cart_items(%Carrito{} = carrito) do
    {_, _} = Repo.delete_all(from(i in CarritoItem, where: i.carrito_id == ^carrito.id))
    {:ok, reload_carrito(carrito)}
  end
end
