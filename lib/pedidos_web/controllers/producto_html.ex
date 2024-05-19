defmodule PedidosWeb.ProductoHTML do
  use PedidosWeb, :html

  embed_templates "producto_html/*"

  @doc """
  Renders a producto form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def producto_form(assigns)
end
