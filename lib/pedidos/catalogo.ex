defmodule Pedidos.Catalogo do
  @moduledoc """
  The Catalogo context.
  """

  import Ecto.Query, warn: false
  alias Pedidos.Catalogo
  alias Pedidos.Repo

  alias Pedidos.Catalogo.Producto

  @doc """
  Returns the list of productos.

  ## Examples

      iex> list_productos()
      [%Producto{}, ...]

  """
  def list_productos do
    Repo.all(Producto)
  end

  @doc """
  Gets a single producto.

  Raises `Ecto.NoResultsError` if the Producto does not exist.

  ## Examples

      iex> get_producto!(123)
      %Producto{}

      iex> get_producto!(456)
      ** (Ecto.NoResultsError)

  """
  def get_producto!(id), do: Repo.get!(Producto, id)

  @doc """
  Creates a producto.

  ## Examples

      iex> create_producto(%{field: value})
      {:ok, %Producto{}}

      iex> create_producto(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_producto(attrs \\ %{}) do
    %Producto{}
    |> Producto.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a producto.

  ## Examples

      iex> update_producto(producto, %{field: new_value})
      {:ok, %Producto{}}

      iex> update_producto(producto, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_producto(%Producto{} = producto, attrs) do
    producto
    |> Producto.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a producto.

  ## Examples

      iex> delete_producto(producto)
      {:ok, %Producto{}}

      iex> delete_producto(producto)
      {:error, %Ecto.Changeset{}}

  """
  def delete_producto(%Producto{} = producto) do
    Repo.delete(producto)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking producto changes.

  ## Examples

      iex> change_producto(producto)
      %Ecto.Changeset{data: %Producto{}}

  """
  def change_producto(%Producto{} = producto, attrs \\ %{}) do
    Producto.changeset(producto, attrs)
  end


  def update_stock(id, cantidad_pedido) do
    producto = get_producto!(id)
    nuevo_stock = producto.stock - cantidad_pedido

    update_producto(producto, %{stock: nuevo_stock})

  end


  def update_stocks(linea_items) do
    Enum.map(linea_items, fn item ->
      update_stock(item.producto_id, item.cantidad)
    end)
    |> Enum.all?(fn result -> elem(result, 0) == :ok end)
    |> case do
       true -> {:ok, linea_items}
       false -> {:error, linea_items}

    end


  end


end
