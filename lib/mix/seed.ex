defmodule Mix.Tasks.Seed do
  use Mix.Task

  @doc "Resets & seeds the DB."

  def run(_) do
    Mix.Task.run "app.start"
    drop_tables()
    create_tables()
    seed_data()
  end

  defp drop_tables() do
    IO.puts("Dropping tables")
    Postgrex.query!(DB, "DROP TABLE IF EXISTS fruits", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS users", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS pizzas", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS ingredients", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS pizza_ingredients", [], pool: DBConnection.ConnectionPool)

    Postgrex.query!(DB, "DROP TABLE IF EXISTS orders", [], pool: DBConnection.ConnectionPool)
  end

  @doc """
  skapar databaserna pizzas, ingredients, pizza_ingredients, users och fruits
  pizza och ingredients JOINas i pizza_ingredients.
  users inehåller användare och deras lösenord som kan gå in på admin sidan

  skapar också tillfällig order db
  """

  defp create_tables() do

    IO.puts("Createing pizzas table")
    Postgrex.query!(DB, "Create TABLE pizzas (id SERIAL, name VARCHAR(255) NOT NULL, image VARCHAR(255) NOT NULL)", [], pool: DBConnection.ConnectionPool)

    IO.puts("creating ingredients table")
    Postgrex.query!(DB, "Create TABLE ingredients (id SERIAL, name VARCHAR(255) NOT NULL)", [], pool: DBConnection.ConnectionPool)

    IO.puts("creating pizza_ingredients table")
    Postgrex.query!(DB, "Create TABLE pizza_ingredients (id SERIAL, p_id INTEGER NOT NULL, i_id INTEGER NOT NULL)", [], pool: DBConnection.ConnectionPool)

    IO.puts("creating users table")
    Postgrex.query!(DB, "Create TABLE users (id SERIAL, name VARCHAR(255) NOT NULL, password_hash VARCHAR(255) NOT NULL)", [], pool: DBConnection.ConnectionPool)

    #temporary orders teble
    IO.puts("creating orders table")
    Postgrex.query!(DB, "Create TABLE orders (id SERIAL, date DATE, order_id INTEGER NOT NULL, customer_name VARCHAR(255) NOT NULL, p_id INTEGER NOT NULL, i_id INTEGER NOT NULL, pizza_done BOOLEAN)", [], pool: DBConnection.ConnectionPool)

    IO.puts("creating fruits table")
    Postgrex.query!(DB, "Create TABLE fruits (id SERIAL, name VARCHAR(255) NOT NULL, tastiness INTEGER NOT NULL)", [], pool: DBConnection.ConnectionPool)
  end

  defp seed_data() do
    IO.puts("Seeding data")

    #lägger till pizzor

    insert_to_pizzas = "INSERT INTO pizzas(name, image) VALUES($1,$2)"
    Postgrex.query!(DB, insert_to_pizzas, ["Margherita", "/uploads/margherita.svg"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_to_pizzas, ["Marinara", "/uploads/marinara.svg"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_to_pizzas, ["Prosciutto e fungi", "/uploads/prosciutto-e-funghi.svg"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_to_pizzas, ["Quattro stagioni", "/uploads/quattro-stagioni.svg"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_to_pizzas, ["Capricciosa", "/uploads/capricciosa.svg"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_to_pizzas, ["Quattro formaggi", "/uploads/quattro-formaggi.svg"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_to_pizzas, ["Ortolana", "/uploads/ortolana.svg"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_to_pizzas, ["Diavola", "/uploads/diavola.svg"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_to_pizzas, ["Anpassad", "/uploads/pizza-question.jpg"], pool: DBConnection.ConnectionPool)

    #lägger till ingredienseer

    insert_to_ingredients = "INSERT INTO ingredients(name) VALUES($1)"
    Postgrex.query!(DB, insert_to_ingredients ,["tomatsås"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_to_ingredients, ["mozzarella"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_to_ingredients, ["basilika"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_to_ingredients, ["skinka"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_to_ingredients, ["svamp"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_to_ingredients, ["kronertskocka"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_to_ingredients, ["oliver"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_to_ingredients, ["parmesan"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_to_ingredients, ["pecorino"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_to_ingredients, ["gorgonzola"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_to_ingredients, ["salami"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_to_ingredients, ["paprika"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_to_ingredients, ["aubergine"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_to_ingredients, ["zucchini"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_to_ingredients, ["chili"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_to_ingredients, ["family_size"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_to_ingredients, ["gluten_free"], pool: DBConnection.ConnectionPool)

    #lägger till connections mellan pizzor och ingredienser

    insert_into_pi = "INSERT INTO pizza_ingredients(p_id, i_id) VALUES($1, $2)"
    Postgrex.query!(DB, insert_into_pi, [1, 1], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_into_pi, [1, 2], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_into_pi, [1, 3], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_into_pi, [2, 1], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_into_pi, [3, 1], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_into_pi, [3, 2], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_into_pi, [3, 4], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_into_pi, [3, 5], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_into_pi, [4, 1], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_into_pi, [4, 2], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_into_pi, [4, 4], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_into_pi, [4, 5], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_into_pi, [4, 6], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_into_pi, [4, 7], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_into_pi, [5, 1], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_into_pi, [5, 2], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_into_pi, [5, 4], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_into_pi, [5, 5], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_into_pi, [5, 6], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_into_pi, [6, 1], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_into_pi, [6, 2], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_into_pi, [6, 8], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_into_pi, [6, 9], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_into_pi, [6, 10],pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_into_pi, [7, 1], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_into_pi, [7, 2], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_into_pi, [7, 12],pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_into_pi, [7, 13],pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_into_pi, [7, 14],pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_into_pi, [8, 1], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_into_pi, [8, 2], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_into_pi, [8, 11],pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_into_pi, [8, 12],pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, insert_into_pi, [8, 15],pool: DBConnection.ConnectionPool)

    #skapar användare

    salted_password = Bcrypt.hash_pwd_salt("pizza")
    Postgrex.query!(DB, "INSERT INTO users(name,password_hash) VALUES($1,$2)", ["admin",salted_password], pool: DBConnection.ConnectionPool)

    #testar temp orders table, order_number står för just den orderns nummer utifall någon skulle beställa två av samma sort

    # insert_into_order = "INSERT INTO orders(date, order_id, customer_name, p_id, i_id, pizza_done) VALUES(CURRENT_DATE,$1,$2,$3,$4,$5)"
    # Postgrex.query!(DB, insert_into_order, [1,"Anna Isaksson",1,1,false], pool: DBConnection.ConnectionPool)
    # Postgrex.query!(DB, insert_into_order, [3,"Jonathan Svensson",1,8,false], pool: DBConnection.ConnectionPool)
    # Postgrex.query!(DB, insert_into_order, [1,"Anna Isaksson",1,3,false], pool: DBConnection.ConnectionPool)
    # Postgrex.query!(DB, insert_into_order, [2,"Jonathan Svensson",1,1,true], pool: DBConnection.ConnectionPool)
    # Postgrex.query!(DB, insert_into_order, [1,"Anna Isaksson",1,2,false], pool: DBConnection.ConnectionPool)
    # Postgrex.query!(DB, insert_into_order, [3,"Jonathan Svensson",1,3,false], pool: DBConnection.ConnectionPool)








    #exempel frukter

    Postgrex.query!(DB, "INSERT INTO fruits(name, tastiness) VALUES($1, $2)", ["Apple", 5], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO fruits(name, tastiness) VALUES($1, $2)", ["Pear", 4], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO fruits(name, tastiness) VALUES($1, $2)", ["Banana", 7], pool: DBConnection.ConnectionPool)
  end

end
