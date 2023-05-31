defmodule Pluggy.KundvagnController do
  require IEx

  alias Pluggy.Pizza

  import Pluggy.Template, only: [render: 2]
  import Plug.Conn, only: [send_resp: 3]

  def kundvagn(conn) do
    # conn = Plug.Conn.put_session(conn, :order, Pizza.get(Plug.Conn.fetch_query_params(conn).params["pizza"]))
    IO.puts "Sessions:"
    IO.inspect(Plug.Conn.get_session(conn)) # Visar alla sessions, för testing
    IO.puts "\nQuery_params:"
    IO.inspect(Plug.Conn.fetch_query_params(conn).params)
    Pizza.add_order(Plug.Conn.fetch_query_params(conn).params, Plug.Conn.get_session(conn, :uuid))
    send_resp(conn, 200, render("pizzas/kundvagn", my_pizzas: Pizza.get_pizza_order(Plug.Conn.get_session(conn, "uuid"))))
  end
end
