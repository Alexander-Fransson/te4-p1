defmodule Pluggy.Router do
  use Plug.Router
  use Plug.Debugger

  alias Pluggy.FruitController
  alias Pluggy.UserController
  alias Pluggy.OrderController
  alias Pluggy.MenuController
  alias Pluggy.KundvagnController

  plug(Plug.Static, at: "/", from: :pluggy)
  plug(:put_secret_key_base)

  plug(Plug.Session,
    store: :cookie,
    key: "_pluggy_session",
    encryption_salt: "cookie store encryption salt",
    signing_salt: "cookie store signing salt",
    key_length: 64,
    log: :debug,
    secret_key_base: "-- LONG STRING WITH AT LEAST 64 BYTES -- LONG STRING WITH AT LEAST 64 BYTES --"
  )

  plug(:fetch_session)
  plug(Plug.Parsers, parsers: [:urlencoded, :multipart])
  plug(:match)
  plug(:dispatch)

  get("/fruits", do: FruitController.index(conn))
  get("/fruits/new", do: FruitController.new(conn))
  get("/fruits/:id", do: FruitController.show(conn, id))
  get("/fruits/:id/edit", do: FruitController.edit(conn, id))

  get("/", do: MenuController.menu(conn))
  get("adminLogin", do: UserController.adminLogin(conn))
  get("/admin", do: OrderController.admin(conn))
  get("/logout", do: UserController.logout(conn)) # FÖR TESTING loggar ut en användare
  get("/pizzas/:id/edit", do: OrderController.edit(conn, id))

  post("/pizzas/:id/edit", do: OrderController.update(conn, id, conn.body_params))

  post("/admin/:order_id/order_ready", do: OrderController.order_ready(conn, order_id, "/admin"))
  post("/admin/:order_id/delete", do: OrderController.delete_order(conn, order_id, "/admin"))

  post("adminLogin", do: UserController.login(conn, conn.body_params))

  get("/kundvagn", do: KundvagnController.kundvagn(conn))

  post("/fruits", do: FruitController.create(conn, conn.body_params))

  # should be put /fruits/:id, but put/patch/delete are not supported without hidden inputs
  post("/fruits/:id/edit", do: FruitController.update(conn, id, conn.body_params))

  # should be delete /fruits/:id, but put/patch/delete are not supported without hidden inputs
  post("/fruits/:id/destroy", do: FruitController.destroy(conn, id))

  post("/users/login", do: UserController.login(conn, conn.body_params))
  post("/users/logout", do: UserController.logout(conn))

  match _ do
    send_resp(conn, 404, "oops")
  end

  defp put_secret_key_base(conn, _) do
    put_in(
      conn.secret_key_base,
      "-- LONG STRING WITH AT LEAST 64 BYTES LONG STRING WITH AT LEAST 64 BYTES --"
    )
  end
end
