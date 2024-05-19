defmodule PedidosWeb.CarritoHTML do
  use PedidosWeb, :html

  alias Pedidos.CarritoDeCompras

  embed_templates "carrito_html/*"

  def currency_to_str(%Decimal{} = val), do: "$#{Decimal.round(val, 2)}"
  end
