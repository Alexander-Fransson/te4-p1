defmodule Pluggy.UserController do
  alias Pluggy.User

  # import Pluggy.Template, only: [render: 2] #det här exemplet renderar inga templates
  import Plug.Conn, only: [send_resp: 3]
  import Pluggy.Template, only: [render: 2, srender: 2]

  def adminLogin(conn) do
    send_resp(conn, 200, render("pizzas/adminLogin", []))
  end

  def adminRedirect(conn), do: redirect(conn, "../admin")

  def login(conn, params) do
    IO.inspect(params)
    username = params["username"]
    password = params["password"]

    result = User.find(username)

    case result.num_rows do
      # no user with that username
      0 ->
        redirect(conn, "../adminLogin")
      # user with that username exists
      _ ->
        [[name, password_hash]] = result.rows

        # make sure password is correct
        if Bcrypt.verify_pass(password, password_hash) do
          Plug.Conn.put_session(conn, :user, name)
          |> redirect("../admin") #skicka vidare modifierad conn
        else
          redirect(conn, "../adminLogin") #fel lösen
        end
    end
  end

  def logout(conn) do
    Plug.Conn.configure_session(conn, drop: true) #tömmer sessionen
    |> redirect("/")
  end

  # def create(conn, params) do
  # 	#pseudocode
  # 	# in db table users with password_hash CHAR(60)
  # 	# hashed_password = Bcrypt.hash_pwd_salt(params["password"])
  #  	# Postgrex.query!(DB, "INSERT INTO users (username, password_hash) VALUES ($1, $2)", [params["username"], hashed_password], [pool: DBConnection.ConnectionPool])
  #  	# redirect(conn, "/fruits")
  # end

  defp redirect(conn, url),
    do: Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
end
