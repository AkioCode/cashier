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

  def checkout(agent) do
    %{basket: Agent.get(agent, &(&1)), price: 0}
    |> calculate_price()
    |> tap(fn _ -> reset_cashier(agent) end)
    |> format_price_and_display()
  end

  defp calculate_price(token) do
    Map.update!(token, :price, fn price ->
      Enum.reduce(token.basket, price, fn {code, amount}, acc ->
        @products[code].price * amount + acc
      end)
    end)
  end

  defp reset_cashier(agent) do
    Agent.update(agent, fn _ -> %{} end)
  end

  defp format_price_and_display(token) do
    token.price
    |> Integer.digits()
    |> Enum.split(-2)
    |> then(fn {euro, cents} ->
      "£#{Enum.join(euro)}.#{Enum.join(cents)}"
    end)
  end
end
