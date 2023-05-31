defmodule Pluggy.OrderController do
  require IEx

  alias Pluggy.Pizza
  alias Pluggy.Ingredient
  alias Pluggy.Fruit
  alias Pluggy
  alias Pluggy.Orders

  import Pluggy.Template, only: [render: 2]
  import Plug.Conn, only: [send_resp: 3]

  def admin(conn) do
    case Plug.Conn.get_session(conn)["user"] do
      "admin" ->
        send_resp(conn, 200, render("pizzas/admin", orders: Orders.get_orders()))
      _ ->
        send_resp(conn, 401, "THE WALL SEES ALL")
    end
  end
  # ["tomato sauce","mozzarella","basil","ham","mushroom","artichoke","olives","parmesan","pecorino","gorgonzola","bell pepper","aubergine","zucchini","salami","chili"]
  def edit(conn, id), do: send_resp(conn, 200, render("pizzas/anpassa", order: [Plug.Conn.fetch_query_params(conn).params,Ingredient.all])) # Bör skicka med nuvarande pizzans ingredienser

  def update(conn, id, params) do
    IO.inspect params
    order_number = Postgrex.query!(DB, "SELECT DISTINCT order_id FROM orders", [], pool: DBConnection.ConnectionPool).num_rows+1
    insert_into_order = "INSERT INTO orders(date, order_id, customer_name, p_id, i_id, pizza_done) VALUES(CURRENT_DATE,$1,$2,$3,$4,$5)"

    Enum.each(params, fn{k, v} ->
      if v != "0" do
        Postgrex.query!(DB, insert_into_order, [order_number,Plug.Conn.get_session(conn, "uuid"),9,String.to_integer(k),false], pool: DBConnection.ConnectionPool)
      end
    end)

    IO.puts "Sending order number #{order_number} to db..."
    redirect(conn, "/kundvagn")
  end

  @doc "deletar en order"

  def delete_order(conn, order_id, url) do
    Postgrex.query!(DB, "DELETE FROM orders WHERE order_id = $1", [String.to_integer(order_id)], pool: DBConnection.ConnectionPool)
    IO.puts "deleted #{order_id}"
    redirect(conn, url)
  end

  def order_ready(conn, order_id, url) do
    Postgrex.query!(DB, "UPDATE orders SET pizza_done = true WHERE order_id = $1", [String.to_integer(order_id)], pool: DBConnection.ConnectionPool)
    IO.puts "Order #{order_id} is done!"
    redirect(conn, url)
  end

  @doc "skapar en form string som skapar en identisk pizza i edit modulen"
  def change_mind(conn, order_id) do
    toppings = Postgrex.query!(DB, "SELECT orders.i_id, ingredients.name FROM orders JOIN ingredients ON ingredients.id = orders.i_id WHERE order_id = $1", [order_id], pool: DBConnection.ConnectionPool).rows
    redirect(conn,"/pizzas/9/edit/#{string_change_mind(toppings,"?")}")
    delete_order(order_id, "test", "test")
  end

  def string_change_mind(list, string) do
    if tl(list) != [] do
      string_change_mind(tl(list), string <> to_string(hd(tl(hd(list)))) <> "=" <> to_string(hd(hd(list))) <> "&")
    else
      string <> to_string(hd(tl(hd(list)))) <> "=" <> to_string(hd(hd(list)))
    end
  end

  defp redirect(conn, url) do
    Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
  end

  # def show(conn), do: send_resp(conn, 200, render("pizzas/admin", orders: Pizza.all()))
end
