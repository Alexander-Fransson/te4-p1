defmodule PluggyTest do
  use ExUnit.Case
  doctest Pluggy

  import Pluggy.Pizza
  alias Pluggy.Pizza

  test "testar delete" do
    assert Pluggy.Orders.delete_order(724356) == "delete"
  end


end
