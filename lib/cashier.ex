defmodule Cashier do
  @moduledoc """
  Documentation for `Cashier`.
  """

  use Agent

  @products %{
    GR1: %{name: "Green tea", price: 311},
    SR1: %{name: "Strawberries", price: 500},
    CF1: %{name: "Coffee", price: 1123}
  }

  def start_link(_opts) do
    Agent.start_link(fn -> %{} end)
  end

  @doc """
  Given a product code or a list of product codes, then add to the basket
  """
  @spec add_to_basket(pid(), atom() | list) :: :ok
  def add_to_basket(agent, [_|_] = product_code_list) do
    Enum.each(product_code_list, &add_to_basket(agent, &1))
  end

  def add_to_basket(agent, product_code) do
    Agent.update(agent, &Map.update(&1, product_code, 1, fn n -> n + 1 end))
  end
end
