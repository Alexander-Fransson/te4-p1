
defmodule Pluggy.Pizza do
  defstruct(
    id: nil,
    name: "",
    image: ""
  )

  alias Pluggy.Pizza

  def all do
    Postgrex.query!(DB, "SELECT id FROM pizzas", [], pool: DBConnection.ConnectionPool).num_rows-1
    |> pizza_formater()
  end

  def get_img(name) do
    if is_binary(name) do
      Postgrex.query!(DB, "SELECT image FROM Pizzas WHERE name = $1 LIMIT 1", [name],
        pool: DBConnection.ConnectionPool
      ).rows |> hd |> hd
    else
      Postgrex.query!(DB, "SELECT image FROM Pizzas WHERE id = $1 LIMIT 1", [name],
        pool: DBConnection.ConnectionPool
      ).rows |> hd |> hd
    end
  end

  def pizza_formater(list_length), do: pizza_formater(list_length,[])
  defp pizza_formater(list_length, acc) when length(acc) == list_length, do: acc
  defp pizza_formater(list_length, acc) do
    selected_data = Postgrex.query!(DB, "SELECT pizzas.id,pizzas.name,pizzas.image,ingredients.id,ingredients.name FROM Pizzas INNER JOIN pizza_ingredients ON pizzas.id = pizza_ingredients.p_id INNER JOIN ingredients ON ingredients.id = pizza_ingredients.i_id WHERE pizzas.id = $1", [length(acc)+1], pool: DBConnection.ConnectionPool).rows
    pizza_formater(list_length, [selected_data | acc])
  end


  def get(id) do
      Postgrex.query!(DB, "SELECT * FROM pizzas WHERE id = $1 LIMIT 1", [String.to_integer(id)],
      pool: DBConnection.ConnectionPool
    ).rows
  end

  def get_pizza_order(uuid) do
    Postgrex.query!(DB, "SELECT DISTINCT order_id FROM orders", [], pool: DBConnection.ConnectionPool).num_rows
    |> specific_order_formater(uuid)
  end

  def specific_order_formater(list_length, uuid), do: specific_order_formater(list_length, uuid, [])
  defp specific_order_formater(list_length, _uuid, acc) when length(acc) == list_length, do: acc
  defp specific_order_formater(list_length, uuid, acc) do
    selected_data = Postgrex.query!(DB, "SELECT orders.order_id,ingredients.name, orders.pizza_done FROM orders INNER JOIN ingredients ON i_id = ingredients.id WHERE customer_name = $1 AND order_id = $2 ORDER BY order_id", [uuid, length(acc)+1], pool: DBConnection.ConnectionPool).rows
    specific_order_formater(list_length, uuid, [selected_data | acc])
  end

  def add_order(map, uuid) do
    clean_map = Map.delete(map, "pizza")
    amount_of_orders = Postgrex.query!(DB, "SELECT DISTINCT order_id FROM orders",[], pool: DBConnection.ConnectionPool).num_rows

    for ingredient <- clean_map do
      Postgrex.query!(DB, "INSERT INTO orders(date, order_id, customer_name, p_id, i_id, pizza_done) VALUES(CURRENT_DATE, $1, $2, $3, $4, $5)", [amount_of_orders+1 , uuid, String.to_integer(map["pizza"]), String.to_integer(elem(ingredient,1)), false], pool: DBConnection.ConnectionPool).rows
    end
  end

  @spec to_struct([[...], ...]) :: %Pluggy.Pizza{id: any, image: any, name: any}
  def to_struct([[id, name, image]]) do
    %Pizza{
      id: id,
      name: name,
      image: image
    }
  end

  def to_struct_list(rows) do
    for [id, name, image] <- rows, do: %Pizza{
      id: id,
      name: name,
      image: image
    }
  end

end

defmodule Pluggy.Orders do
  defstruct(
    date: "",
    order_id: nil,
    customer_name: "",
    ingredient: "",
    pizza_done: nil
  )
  alias Pluggy.Orders

  def order_struct(rows) do
    for [date, order_id, customer_name, ingredient, pizza_done] <- rows, do: %Orders{
      date: date,
      order_id: order_id,
      customer_name: customer_name,
      ingredient: ingredient,
      pizza_done: pizza_done
    }
  end

  def get_orders() do

    IO.inspect(Postgrex.query!(DB, "
      SELECT orders.date, orders.order_id, orders.customer_name, ingredients.name, orders.pizza_done
      FROM orders
      LEFT JOIN ingredients ON orders.i_id=ingredients.id
      ORDER BY order_id DESC",
      [], pool: DBConnection.ConnectionPool)).rows
      |> order_struct()

  end

end
