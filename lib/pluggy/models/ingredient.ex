defmodule Pluggy.Ingredient do

  # OBS denna fil är för tillfället halft i bruk, men jag arbetar med att implementera den senare. Syftet är att skicka ingredienserna till anpassa.ex beroende på vilken pizza man anpassar // Jack

  # defstruct(
  #   tomatosauce: "",
  #   mozzarella: "",
  #   basil: "",
  #   ham: "",
  #   mushroom: "",
  #   artichoke: "",
  #   olives: "",
  #   parmesan: "",
  #   pecorino: "",
  #   gorgonzola: "",
  #   bell_pepper: "",
  #   aubergine: "",
  #   zucchini: "",
  #   salami: "",
  #   chili: ""
  # )

  #alias Pluggy.Ingredient

  def all do
    Postgrex.query!(DB, "SELECT name FROM ingredients", [], pool: DBConnection.ConnectionPool).rows
  end

  # def get(id) do
  #   Postgrex.query!(DB, "SELECT name FROM ingredients WHERE p_id = $1", [String.to_integer(id)], pool: DBConnection.ConnectionPool).rows
  # end


  # def to_struct([[id1], [id2], [id3], [id4], [id5], [id6], [id7], [id8], [id9], [id10], [id11], [id12], [id13], [id14], [id15]]) do
  #   %Ingredient{
  #     tomatosauce: id1,
  #     mozzarella: id2,
  #     basil: id3,
  #     ham: id4,
  #     mushroom: id5,
  #     artichoke: id6,
  #     olives: id7,
  #     parmesan: id8,
  #     pecorino: id9,
  #     gorgonzola: id10,
  #     bell_pepper: id11,
  #     aubergine: id12,
  #     zucchini: id13,
  #     salami: id14,
  #     chili: id15
  #   }
  # end
end
