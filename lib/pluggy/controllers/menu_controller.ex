defmodule Pluggy.MenuController do
  require IEx

  alias Pluggy.Pizza

  import Pluggy.Template, only: [render: 2]
  import Plug.Conn, only: [send_resp: 3]

  def menu(conn) do
    IO.inspect(conn.private.plug_session) # Skriver bara ut uuid:n
    if conn.private.plug_session["uuid"] == nil do
      Plug.Conn.put_session(conn, :uuid, UUID.uuid3(UUID.uuid1(),Plug.Conn.request_url(conn)))
      |> redirect("/")
    end
    send_resp(conn, 200, render("pizzas/menu", pizzas: Pizza.all()))
  end

  defp redirect(conn, url) do
    Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
  end
end
