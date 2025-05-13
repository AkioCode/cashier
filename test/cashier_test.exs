defmodule CashierTest do
  use ExUnit.Case
  doctest Cashier
  alias Cashier

  setup do
    {:ok, agent} = Cashier.start_link([])
    %{agent: agent}
  end

  test "Given a product code to `add_to_basket/2`, then increment its counter", %{agent: agent} do
    assert Cashier.add_to_basket(agent, :GR1) == :ok
    assert %{GR1: 1} = Agent.get(agent, &(&1))
  end

  test "Given a list of product codes to `add_to_basket/1`, then increment each counter", %{agent: agent} do
    assert Cashier.add_to_basket(agent, [:GR1, :CF1, :CF1, :GR1, :STR1]) == :ok
    assert %{CF1: 2, GR1: 2, STR1: 1} == Agent.get(agent, &(&1))
  end

  test "Given one GR1 in the basket, then don't apply any discount", %{agent: agent} do
    Cashier.add_to_basket(agent, :GR1)
    assert Cashier.checkout(agent) === "£3.11"
  end

  test "Given a list of product codes to `add_to_basket/1`, then store it" do

  end

  test "Given pair(s) of GR1 in the basket, then apply 50% discount on GR1" do

  end

  test "Given n GR1 in the basket, when n > 1 and it's an odd number, then apply 50% discount on n-1 GR1 sum" do

  end

  test "Given less than 3 SR1 in the basket, then don't apply any discount", %{agent: agent} do
    Cashier.add_to_basket(agent, :SR1)
    assert Cashier.checkout(agent) === "£5.00"
  end

  test "Given more than 2 SR1 in the basket, then lower its price to 4.50" do
  end

  test "Given less than 2 CF1 in the basket, then don't apply any discount", %{agent: agent} do
    Cashier.add_to_basket(agent, :CF1)
    assert Cashier.checkout(agent) === "£11.23"
  end

  test "Given more than 2 CF1 in the basket, then apply a 2/3 discount on the price of all coffees" do

  end
end
