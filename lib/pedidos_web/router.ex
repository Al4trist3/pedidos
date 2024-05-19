defmodule PedidosWeb.Router do
  use PedidosWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PedidosWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
    plug :fetch_current_cart
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PedidosWeb do
    pipe_through :browser

    get "/", PageController, :home

    resources "/productos", ProductoController

    resources "/carrito_items", CarritoItemController, only: [:create, :delete]
    get "/carrito", CarritoController, :show
    put "/carrito", CarritoController, :update
    resources "/ordenes", OrdenController, only: [:create, :show]

  end

  # Other scopes may use custom stacks.
  # scope "/api", PedidosWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:pedidos, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PedidosWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  defp fetch_current_user(conn, _) do
       if user_uuid = get_session(conn, :current_uuid) do
         assign(conn, :current_uuid, user_uuid)
       else
         new_uuid = Ecto.UUID.generate()

         conn
         |> assign(:current_uuid, new_uuid)
         |> put_session(:current_uuid, new_uuid)
       end
     end

     alias Pedidos.CarritoDeCompras.CarritoItem
     alias Pedidos.CarritoDeCompras

     defp fetch_current_cart(conn, _opts) do
       if cart = CarritoDeCompras.get_cart_by_user_uuid(conn.assigns.current_uuid) do
         assign(conn, :carrito, cart)
       else
         {:ok, new_cart} = CarritoDeCompras.create_carrito(conn.assigns.current_uuid)
         assign(conn, :carrito, new_cart)
       end
     end
end
